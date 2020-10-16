data "template_file" "nginx" {
  template = "${file("${path.module}/template/install_nginx.tpl")}"

  vars = {
    ufw_allow_nginx = "Nginx HTTP"
  }
}