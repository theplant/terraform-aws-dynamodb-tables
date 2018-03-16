data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "table" {
  count          = "${length(var.table_info)}"
  name           = "${lookup(var.table_info[count.index], "name")}"
  read_capacity  = "${lookup(var.table_info[count.index], "read_capacity", "1")}"
  write_capacity = "${lookup(var.table_info[count.index], "write_capacity", "1")}"
  hash_key       = "ItemKey"

  attribute {
    name = "ItemKey"
    type = "S"
  }

  tags = "${var.tags}"
}

resource "aws_iam_user" "dynamodb" {
  count = "${length(var.users)}"
  name = "tf-${element(var.users, count.index)}"
}

resource "aws_iam_access_key" "dynamodb" {
  count = "${length(var.users)}"
  user  = "${element(aws_iam_user.dynamodb.*.name, count.index)}"
}

resource "aws_iam_policy" "policy" {
    count = "${length(var.table_info)}"
    name  = "tf-${md5(join(",", var.users))}-${lookup(var.table_info[count.index], "name")}-rw"
    policy =<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "Stmt1496219736000",
        "Action": ["dynamodb:*"],
        "Effect": "Allow",
        "Resource": ["arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${lookup(var.table_info[count.index],"name")}"]
    }
  ]
}
POLICY
}

resource "aws_iam_user_policy_attachment" "attach" {
    count = "${length(var.table_info)*length(var.users)}"
    user       = "${element(aws_iam_user.dynamodb.*.name, count.index / length(var.table_info))}"
    policy_arn = "${element(aws_iam_policy.policy.*.arn, count.index % length(var.table_info))}"
}