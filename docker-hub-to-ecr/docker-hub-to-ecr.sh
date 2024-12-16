source_repo=$1
image_tag=$2
destination_image_name=$3
profile=$4
docker_registry=$5

docker_login() {
  aws ecr get-login-password --region us-west-2 --profile $profile | docker login $docker_registry --username AWS --password-stdin
}

docker_pull_and_tag() {
  docker pull --platform=linux/amd64 $source_repo:$image_tag
  docker tag $source_repo:$image_tag $source_repo:$image_tag-amd
  docker tag $source_repo:$image_tag-amd $docker_registry/$destination_image_name:$image_tag-amd

  docker pull --platform=linux/arm64 $source_repo:$image_tag
  docker tag $source_repo:$image_tag $source_repo:$image_tag-arm
  docker tag $source_repo:$image_tag-arm $docker_registry/$destination_image_name:$image_tag-arm
}

docker_push() {
  docker push $docker_registry/$destination_image_name:$image_tag-amd
  docker push $docker_registry/$destination_image_name:$image_tag-arm

  docker manifest create $docker_registry/$destination_image_name:$image_tag \
    --amend $docker_registry/$destination_image_name:$image_tag-amd \
    --amend $docker_registry/$destination_image_name:$image_tag-arm

  docker manifest push $docker_registry/$destination_image_name:$image_tag
}

create_ecr() {
  aws ecr describe-repositories --repository-name $destination_image_name --profile $profile || \
  aws ecr create-repository --repository-name $destination_image_name --profile $profile
}

docker_login
create_ecr
docker_pull_and_tag
docker_push