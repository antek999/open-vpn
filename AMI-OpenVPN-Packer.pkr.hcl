# If you don't set a default, then you will need to provide the variable
# at run time using the command line, or set it in the environment. For more
# information about the various options for setting variables, see the template
# [reference documentation](https://www.packer.io/docs/templates)
#variable "ami_name" {
#  type    = string
#  default = "AMI-OpenVPN"
#}



locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks configure your builder plugins; your source is then used inside
# build blocks to create resources. A build block runs provisioners and
# post-processors on an instance created by the source.
source "amazon-ebs" "example" {
  access_key    = "${var.aws_access_key}"
  ami_name      = "AMI-OpenVPN ${local.timestamp}"
  instance_type = "${var.instance_type_packer}"
  region        = "${var.region_for_packer}"
  secret_key    = "${var.aws_secret_key}"
  source_ami = "${var.source_packer_ami}"
  ssh_username = "ubuntu"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.amazon-ebs.example"]



provisioner "file"{
  source = "client-configs"
  destination = "/tmp"
}

provisioner "file"{
  source = "easy-rsa"
  destination = "/tmp"
}

provisioner "file"{
  source = "easy-rsa-CA"
  destination = "/tmp"
}

provisioner "file"{
  source = "before.rules"
  destination = "/tmp/before.rules"
}

provisioner "file"{
  source = "server.conf"
  destination = "/tmp/server.conf"
}

provisioner "file"{
  source = "sysctl.conf"
  destination = "/tmp/sysctl.conf"
}

provisioner "file"{
  source = "ufw"
  destination = "/tmp/ufw"
}

provisioner "file"{
  source = "openssl-easyrsa.cnf"
  destination = "/tmp/"
}


  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y openvpn easy-rsa",

      "sudo cp /usr/share/easy-rsa/easyrsa /usr/local/bin",
      "sudo cp /tmp/ufw /etc/default",
      "sudo cp /tmp/before.rules /etc/ufw/",
      "sudo cp /tmp/sysctl.conf /etc/",
      "sudo cp /tmp/server.conf /etc/openvpn/server/",
      "sudo cp -r /tmp/client-configs /srv",

      "sudo easyrsa --pki-dir=/srv/easy-rsa-CA/pki init-pki",
      "sudo easyrsa --pki-dir=/srv/easy-rsa/pki init-pki",

      "sudo cp -r /tmp/easy-rsa-CA/* /srv/easy-rsa-CA/",
      "sudo cp -r /tmp/easy-rsa/* /srv/easy-rsa/",

      "sudo ln -s /usr/share/easy-rsa/* /srv/easy-rsa/",
      "sudo ln -s /usr/share/easy-rsa/* /srv/easy-rsa-CA/",

      "sudo ls -la /srv/easy-rsa-CA/",


      "sudo cp /tmp/openssl-easyrsa.cnf /srv/easy-rsa-CA/pki/",

      "sudo easyrsa --batch --pki-dir=/srv/easy-rsa-CA/pki build-ca nopass",
      "sudo cp /tmp/openssl-easyrsa.cnf /srv/easy-rsa/pki/",
      "sudo /srv/easy-rsa/easyrsa --batch --pki-dir=/srv/easy-rsa/pki gen-req server nopass",

      "sudo cp /srv/easy-rsa/pki/private/server.key /etc/openvpn/server/",
      "sudo /srv/easy-rsa/easyrsa --batch --pki-dir=/srv/easy-rsa-CA/pki import-req /srv/easy-rsa/pki/reqs/server.req server ",
      "sudo /srv/easy-rsa/easyrsa --batch --pki-dir=/srv/easy-rsa-CA/pki sign-req server server ",

      "sudo cp /srv/easy-rsa-CA/pki/issued/server.crt /etc/openvpn/server/",
      "sudo cp /srv/easy-rsa-CA/pki/ca.crt /etc/openvpn/server/",

      "sudo openvpn --cd /srv/easy-rsa --genkey --secret /etc/openvpn/server/ta.key ",

      "sudo /srv/easy-rsa/easyrsa --batch --pki-dir=/srv/easy-rsa/pki gen-req client1 nopass ",
      "sudo cp /srv/easy-rsa/pki/private/client1.key /srv/client-configs/keys/",

      "sudo /srv/easy-rsa/easyrsa --batch --pki-dir=/srv/easy-rsa-CA/pki import-req /srv/easy-rsa/pki/reqs/client1.req client1 ",
      "sudo /srv/easy-rsa/easyrsa --batch --pki-dir=/srv/easy-rsa-CA/pki sign-req client client1",

      "sudo cp /srv/easy-rsa-CA/pki/issued/client1.crt /srv/client-configs/keys/",
      "sudo cp /etc/openvpn/server/ta.key /srv/client-configs/keys/",
      "sudo cp /etc/openvpn/server/ca.crt /srv/client-configs/keys/",
    ]
  }
}
