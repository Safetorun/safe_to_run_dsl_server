./gradlew buildLambda
mv build/distributions/kotlin-compiler-server-1.6.21-SNAPSHOT.zip lambda.zip
aws s3 cp lambda.zip s3://kotlincompiler
cd terraform && terraform init && terraform apply -auto-approve