packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "ubuntu" { # -> what kind of source is used to create an instance
  ami_name      = "wordpress-{{ timestamp }}" #->make ami with diff names
  instance_type = "t3.micro"
  region        = "us-east-1"
  source_ami    = "ami-0f8a61b66d1accaee"
  ssh_username  = "ubuntu"
  ssh_keypair_name = "my-laptop-key"
  ssh_private_key_file = "~/.ssh/id_rsa" #-> ssh ec2-user@ip -i priv key loc - specify where private key leaves
}
build {        # build ami from abow instance
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" { #-> shell provisioner.  script = "script.sh"  # or inline = [    ]
    #inline = ["ansible-playbook main.yml"]
    playbook_file = "main.yml"  
  }
}
