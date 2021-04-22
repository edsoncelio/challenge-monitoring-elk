source "amazon-ebs" "ec2-elk" {
  ami_name      = "${var.ami_name}-${local.timestamp}"
  instance_type = "${var.instance_type}"
  region        = "${var.region}"
  source_ami = "${var.source_ami}"
  ssh_username = "${var.ssh_username}"
  tags = {
    created_by = "packer"
  }
}

build {
  sources = ["source.amazon-ebs.ec2-elk"]

  provisioner "shell-local" {
    inline = ["ansible-galaxy install -r ./playbook/requirements.yml"]
  }

  provisioner "ansible" {
      playbook_file = "./playbook/main.yml"
  }

}


