provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "besu_node" {
  ami           = "ami-0abcdef1234567890" # Replace with a valid AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "BesuNode"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y besu",
      "besu --network=mainnet"
    ]
  }
}