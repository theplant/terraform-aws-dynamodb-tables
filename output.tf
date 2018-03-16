output "tables" {
  description = "The user and name of the dynamodb tables"
  value = ["${aws_dynamodb_table.table.*.name}"]
  value       =  {
    buckets = "${var.table_info}"
    access_key_id = "${aws_iam_access_key.dynamodb.id}"
    secret_access_key = "${aws_iam_access_key.dynamodb.secret}"
  }
}
