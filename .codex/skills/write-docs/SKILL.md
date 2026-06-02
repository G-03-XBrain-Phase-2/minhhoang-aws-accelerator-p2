---

name: write-lab-readme
description: Read a lab folder and write README.md in Vietnamese
---

---

# Write Lab README

Input: $ARGUMENTS

## Goal

Đọc thư mục lab, ví dụ `w8/d1`, rồi tạo hoặc cập nhật `README.md` trong thư mục đó bằng tiếng Việt.

README cần tóm tắt đúng lab đang có trong folder.

## Workflow

1. Xác định folder lab:

```bash
w8/d1
```

Dùng `$ARGUMENTS` nếu có. Nếu không có thì hỏi lại user.

2. Kiểm tra file trong lab:

```bash
find <lab-folder> -maxdepth 3 -type f
```

3. Đọc các file quan trọng nếu có:

```bash
cat <lab-folder>/README.md
cat <lab-folder>/*.tf
cat <lab-folder>/package.json
cat <lab-folder>/docker-compose.yml
cat <lab-folder>/Dockerfile
```

4. Viết hoặc cập nhật:

```bash
<lab-folder>/README.md
```

Gợi ý nội dung:

```markdown
# W8 D1 - Tên lab ngắn

## Tóm tắt lab

## Mục tiêu

## Nội dung thực hiện

## Công nghệ sử dụng

## Cấu trúc file

## Cách chạy

## Kiểm tra kết quả

## Dọn dẹp tài nguyên

## Ghi chú
```

5. Xem thay đổi:

```bash
git diff <lab-folder>/README.md
```

## Rules

- Viết README bằng tiếng Việt
- Chỉ sửa `README.md` trong folder lab đó
- Tóm tắt đúng lab trong folder
- Không bịa tính năng hoặc lệnh chạy
- Ưu tiên thông tin từ file thật
- Ngắn gọn, dễ hiểu
- Nếu thiếu thông tin thì ghi cần kiểm tra thêm
