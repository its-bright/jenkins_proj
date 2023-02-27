provider "aws" {
    region = "<aws region>"
    profile = "<profile>"
}

terraform { 
    backend "s3" {
        bucket = "<state file bucket>"
        key = "< state file name>"
        region = "<aws region>"
        encrypt = true
        profile = "<profile>"
    }
}