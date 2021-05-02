resource "null_resource" "runansible" {
  provisioner "local-exec" {

    command = "cp dbhostname /home/ruben/epam-terraform-homework/homework-2/roles/wordpress/templates/wp-config.php.j2"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory_aws_ec2.yaml playbook_dynamic.yaml"

  }
  depends_on = [
    aws_db_instance.default
  ]

}