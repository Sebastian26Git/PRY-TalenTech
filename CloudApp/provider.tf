terraform {
  backend "s3" {
    bucket         = "codepipeline-us-east-1-590125552616"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}