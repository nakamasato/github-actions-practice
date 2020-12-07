mkdir /tmp/data
mkdir /tmp/config

# イメージダウンロード
docker pull minio/minio

# dockerコンテナ起動
docker run -p 9000:9000 --name minio \
  -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" \
  -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" \
  -v /tmp/data:/data \
  -v /tmp/config:/root/.minio \
  minio/minio server /data

# URL確認（コンテナ起動時に表示される）
docker logs minio
