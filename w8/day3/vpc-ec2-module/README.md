# W8 Day 3 - VPC EC2 Module

## Tóm tắt lab

Lab này dùng Terraform để tạo hạ tầng AWS gồm VPC, Internet Gateway, public subnets, route table public và một EC2 instance chạy Amazon Linux 2023. Phần network được tách thành module riêng trong `modules/network`.

## Mục tiêu

- Thực hành tách cấu hình Terraform thành root module và child module.
- Tạo VPC với CIDR `10.0.0.0/16`.
- Tạo 2 public subnet theo 2 Availability Zone đầu tiên trong region.
- Gắn Internet Gateway và route `0.0.0.0/0` cho public route table.
- Tạo một EC2 `t3.micro` trong public subnet đầu tiên.

## Nội dung thực hiện

Root module trong `main.tf`:

- Cấu hình AWS provider ở region `ap-southeast-1` với profile `default`.
- Lấy danh sách Availability Zone đang available.
- Lấy AMI Amazon Linux 2023 mới nhất từ owner `amazon`.
- Gọi module `network` để tạo VPC và subnet.
- Tạo EC2 instance `WebServer`.
- Xuất các output: `instance_id`, `instance_public_ip`, `vpc_id`, `public_subnet_ids`.

Module `modules/network`:

- Nhận biến `vpc_name`, `vpc_cidr`, `public_subnet`.
- Tạo `aws_vpc`.
- Tạo `aws_internet_gateway`.
- Tạo các `aws_subnet` bằng `for_each`.
- Tạo public route table và gắn route ra Internet Gateway.
- Associate các subnet vào route table public.
- Xuất `vpc_id` và danh sách `public_subnet_ids`.

## Công nghệ sử dụng

- Terraform `>= 1.10`
- AWS provider `~> 6.0`
- AWS VPC, Subnet, Internet Gateway, Route Table
- AWS EC2
- Amazon Linux 2023 AMI

## Cấu trúc file

Các file chính của lab:

```text
vpc-ec2-module/
+-- main.tf
+-- modules/
    +-- network/
        +-- main.tf
        +-- outputs.tf
        +-- variables.tf
```

## Cách chạy

Chạy các lệnh trong thư mục `w8/day3/vpc-ec2-module`:

```bash
terraform init
terraform plan
terraform apply
```

Terraform đang dùng AWS profile `default`, vì vậy cần cấu hình credentials phù hợp trước khi chạy.

## Kiểm tra kết quả

Sau khi `terraform apply` thành công, kiểm tra các output:

```bash
terraform output
```

Có thể đối chiếu trên AWS Console:

- VPC tên `my-vpc`
- Internet Gateway tên `my-vpc-igw`
- 2 public subnet với CIDR `10.0.1.0/24` và `10.0.2.0/24`
- EC2 instance có tag `Name = WebServer`

## Dọn dẹp tài nguyên

Chạy lệnh sau trong thư mục lab:

```bash
terraform destroy
```

## Ghi chú

- Lab có file state local trong thư mục hiện tại; cần cẩn thận khi commit hoặc chia sẻ repository.
- Subnet có route ra Internet Gateway, nhưng module chưa cấu hình `map_public_ip_on_launch`, security group riêng hoặc key pair. Nếu cần SSH/truy cập EC2 từ Internet thì cần kiểm tra và bổ sung thêm.
