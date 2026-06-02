# W8 Day 1 - Terraform S3 Remote Backend

## Tóm tắt lab

Lab này thực hành tạo S3 bucket bằng Terraform để dùng làm remote backend, sau đó cấu hình một Terraform project khác trong thư mục `main/` lưu state lên S3 backend đó.

## Mục tiêu

- Tạo S3 bucket làm backend lưu Terraform state.
- Bật versioning cho bucket backend.
- Bật mã hóa server-side bằng `AES256`.
- Chặn public access cho bucket backend.
- Cấu hình Terraform backend `s3` trong thư mục `main/`.
- Tạo một S3 bucket riêng bằng Terraform với state được lưu trên S3 backend.

## Nội dung thực hiện

### 1. Bootstrap S3 backend

File `s3-backend.tf` ở thư mục `w8/day1` tạo các tài nguyên:

- `aws_s3_bucket.local`: S3 bucket có `bucket_prefix = "s3-backend-"` và `force_destroy = true`.
- `aws_s3_bucket_versioning.local`: bật versioning cho bucket.
- `aws_s3_bucket_server_side_encryption_configuration.local`: bật mã hóa mặc định `AES256`.
- `aws_s3_bucket_public_access_block.local`: chặn public ACL và public policy.

Theo file `terraform.tfstate` hiện có, Terraform output gồm:

- `bucket_name`: `s3-backend-20260602034907737900000001`
- `bucket_arn`: `arn:aws:s3:::s3-backend-20260602034907737900000001`

### 2. Sử dụng S3 backend trong project main

File `main/main.tf` cấu hình backend:

- `bucket`: `s3-backend-20260602034907737900000001`
- `key`: `./terraform.tfstate`
- `region`: `ap-southeast-1`
- `encrypt`: `true`
- `use_lockfile`: `true`

Thư mục `main/` cũng tạo một S3 bucket với `bucket_prefix = "s3-backend-"` và tag:

- `Environment = "Dev"`
- `Owner = "Minh Hoang"`

## Công nghệ sử dụng

- Terraform `>= 1.10`
- AWS Provider `hashicorp/aws` `~> 6.0`
- AWS Provider đã lock ở phiên bản `6.47.0`
- AWS S3
- Region: `ap-southeast-1`
- AWS profile: `default`

## Cấu trúc file

```text
w8/day1/
|-- README.md
|-- s3-backend.tf
|-- .terraform.lock.hcl
|-- terraform.tfstate
|-- terraform.tfstate.backup
`-- main/
    |-- main.tf
    |-- .terraform.lock.hcl
    `-- .terraform/
```

Ghi chú: `.terraform/`, `.terraform.lock.hcl` và `terraform.tfstate*` là các file/thư mục sinh ra khi chạy Terraform.

## Cách chạy

### 1. Tạo bucket backend

```bash
cd w8/day1
terraform init
terraform plan
terraform apply
```

Lấy tên bucket backend:

```bash
terraform output bucket_name
```

### 2. Chạy project dùng remote backend

```bash
cd w8/day1/main
terraform init
terraform plan
terraform apply
```

Nếu tạo lại bucket backend với tên mới, cần cập nhật giá trị `bucket` trong block `backend "s3"` của file `main/main.tf` trước khi chạy `terraform init`.

## Kiểm tra kết quả

Tại thư mục `w8/day1`, kiểm tra output:

```bash
terraform output
terraform state list
```

Tại thư mục `w8/day1/main`, kiểm tra state và tài nguyên:

```bash
terraform state list
terraform show
```

Nếu có AWS CLI, có thể kiểm tra bucket:

```bash
aws s3 ls
```

## Dọn dẹp tài nguyên

Nên xóa tài nguyên trong `main/` trước, sau đó mới xóa bucket backend:

```bash
cd w8/day1/main
terraform destroy
```

```bash
cd w8/day1
terraform destroy
```

## Ghi chú

- Backend bucket đang được khai báo cố định trong `main/main.tf`.
- Bucket có `force_destroy = true`, nên Terraform có thể xóa bucket kể cả khi bucket có object.
- Lab đang sử dụng AWS profile `default`; cần đảm bảo credential và quyền AWS phù hợp trước khi chạy.
