#!/bin/bash

# Настройки
S3_BUCKET="remote-state-bakur-outfit-fisting"
BACKUP_DIR="/home/bakur/Study/Proj_v3/terraform"
BACKUP_PREFIX="backup"
BACKUP_RETENTION_DAYS=7
AWS_CLI_PROFILE="bakur"

# Создание временного каталога
TMP_DIR=$(mktemp -d)

# Создание резервной копии и загрузка в S3
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_FILENAME="${BACKUP_PREFIX}-${TIMESTAMP}.tar.gz"
tar -czf "${TMP_DIR}/${BACKUP_FILENAME}" "${BACKUP_DIR}"
aws --profile "${AWS_CLI_PROFILE}" s3 cp "${TMP_DIR}/${BACKUP_FILENAME}" "s3://${S3_BUCKET}/${BACKUP_FILENAME}"

# Удаление старых резервных копий
aws --profile "${AWS_CLI_PROFILE}" s3 ls "s3://${S3_BUCKET}" | while read -r line;
  do
    createDate=$(echo $line|awk {'print $1" "$2'})
    createDate=$(date -d "$createDate" +%s)
    if [[ $(( $(date +%s) - $createDate )) > $(( ${BACKUP_RETENTION_DAYS} * 24 * 60 * 60 )) ]];
      then
        fileName=$(echo $line|awk {'print $4'})
        if [[ $fileName == ${BACKUP_PREFIX}* ]];
          then
            aws --profile "${AWS_CLI_PROFILE}" s3 rm "s3://${S3_BUCKET}/${fileName}"
        fi
    fi
done

# Удаление временного каталога
rm -rf "${TMP_DIR}"
