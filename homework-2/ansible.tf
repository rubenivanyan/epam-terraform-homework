#Create db_connection_config file
resource "local_file" "dbhostname" {
  content = templatefile("${var.configpath}",
    {
      dbhostname = aws_db_instance.default.address
    }
  )

  filename = "dbhostname"
}
#Run Ansible                                
resource "null_resource" "runansible" {
  provisioner "local-exec" {

    command = "cp dbhostname ${var.configpath2}"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory_aws_ec2.yaml playbook_dynamic.yaml --ask-vault-password"

  }
  depends_on = [
    aws_db_instance.default
  ]

}