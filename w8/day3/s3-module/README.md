# W8 Day 3 - S3 Module

## Tóm tắt lab

Lab này tạo một Terraform module để quản lý S3 bucket trên AWS. Root module gọi lại module trong thư mục `modules` để tạo 2 bucket S3 với cấu hình khác nhau cho dữ liệu và log.

## Mục tiêu

- Tạo module Terraform tái sử dụng cho S3 bucket.
- Cấu hình bucket name bằng `bucket_prefix`.
- Bật hoặc tạm dừng versioning theo biến đầu vào.
- Bật mã hóa mặc định phía server bằng AES256.
- Chặn public access cho bucket.
- Xuất `id` và `arn` của bucket từ module.

## Nội dung thực hiện

- `main.tf` ở root cấu hình Terraform, AWS provider và gọi module S3.
- Module `data` tạo bucket với prefix `my-s3-bucket-`, bật versioning và cho phép `force_destroy`.
- Module `logs` tạo bucket với prefix `my-s3-logs-bucket-`, không bật versioning và không cho phép `force_destroy`.
- Module trong `modules/` tạo các tài nguyên:
  - `aws_s3_bucket`
  - `aws_s3_bucket_versioning`
  - `aws_s3_bucket_server_side_encryption_configuration`
  - `aws_s3_bucket_public_access_block`

## Công nghệ sử dụng

- Terraform `>= 1.10`
- AWS Provider `~> 6.0`
- AWS S3
- AWS region: `ap-southeast-1`
- AWS profile: `default`

## Cấu trúc file

```text
w8/day3/s3-module/
|-- main.tf
|-- README.md
|-- modules/
|   |-- main.tf
|   |-- outputs.tf
|   `-- variables.tf
```

Ghi chú: `.terraform/`, `terraform.tfstate` và `terraform.tfstate.backup` là file/thư mục sinh ra khi chạy Terraform.

## Cách chạy

Chạy trong thư mục lab:

```bash
cd w8/day3/s3-module
terraform init
terraform plan
terraform apply
```

Khi chạy `terraform apply`, kiểm tra plan và nhập xác nhận theo yêu cầu của Terraform.

## Kiểm tra kết quả

Xem output sau khi apply:

```bash
terraform output
```

README kỳ vọng có output:

- `data`: id của bucket dữ liệu.
- `logs`: id của bucket log.

Có thể kiểm tra thêm trên AWS Console trong region `ap-southeast-1` hoặc dùng AWS CLI nếu đã cấu hình quyền phù hợp.

## Dọn dẹp tài nguyên

Chạy lệnh sau trong thư mục lab:

```bash
terraform destroy
```

Lưu ý: bucket `data` có `force_destroy = true`, còn bucket `logs` có `force_destroy = false`. Nếu bucket `logs` có object bên trong, cần xóa object trước khi destroy.

## Ghi chú

- Cần có AWS credentials cho profile `default` trước khi chạy.
- Tên bucket được Terraform tạo tự động từ prefix nên sẽ có hậu tố ngẫu nhiên.
- Cần kiểm tra thêm quyền IAM nếu Terraform không thể tạo hoặc xóa bucket.
