./gradlew buildLambda
curl -o 1.6.21/SafeToRunConfiguration.jar  https://github.com/Safetorun/safe_to_run/releases/download/2.1.1/safeToRunInternal-2.1.1-all.jar
cd terraform && terraform init && terraform apply -auto-approve