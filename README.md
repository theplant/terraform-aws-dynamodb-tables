# Terraform AWS Dynamodb Tables

This module simplifies creating dynamodb tables. The minimum information required is a name for the table, each table can then contain different values for read/write capacity.

## Example

```
hcl
module "tables" {
  source     = "vistaprint/dynamodb_tables/aws"
  users      = ["aaa","ccc"]
  region     = "ap-northeast-1"
  table_info = [
    {
      name = "${var.prefix}Table1"
    },
    {
      name = "${var.prefix}Table2"
      read_capacity = 2
      write_capacity = 2
    }
}
```

So it will create different tables which described in `table_info`, and create IAM account described in `users`. Then make each user to access all of the tables we described in `table_info`.


* referenece: https://github.com/vistaprint/terraform-aws-dynamodb-tables
