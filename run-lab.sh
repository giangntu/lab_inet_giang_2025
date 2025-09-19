#!/bin/bash

if [ $# -eq 0 ]; then
    echo "📌 Cách dùng: ./run-lab.sh <tên_lab> [config]"
    echo "   Ví dụ: ./run-lab.sh lab01 Wireless01"
    echo ""
    echo "📋 Danh sách lab:"
    ls labs/
    exit 1
fi

LAB_DIR="labs/$1"
CONFIG=${2:-General}

if [ ! -d "$LAB_DIR" ]; then
    echo "❌ Không tìm thấy thư mục: $LAB_DIR"
    exit 1
fi

echo "🚀 Vào thư mục: $LAB_DIR"
cd "$LAB_DIR"

# Kiểm tra xem có omnetpp.ini không
if [ ! -f "omnetpp.ini" ]; then
    echo "⚠️ Cảnh báo: Không tìm thấy omnetpp.ini trong $LAB_DIR"
    echo "→ Vui lòng thêm file omnetpp.ini và *.ned vào thư mục này trước khi chạy."
    exit 1
fi

echo "🔧 Biên dịch..."
make clean 2>/dev/null
make || { echo "❌ Lỗi biên dịch!"; exit 1; }

EXECUTABLE=$(basename $LAB_DIR)
if [ ! -f "$EXECUTABLE" ]; then
    echo "❌ Không tìm thấy file thực thi: $EXECUTABLE"
    echo "→ Có thể do chưa có file .ned hoặc lỗi biên dịch."
    exit 1
fi

echo "▶️ Chạy mô phỏng với cấu hình: [$CONFIG]..."
./$EXECUTABLE -u Cmdenv -c $CONFIG omnetpp.ini --cmdenv-express-mode=true

mkdir -p ../../output/$1
cp results/* ../../output/$1/ 2>/dev/null

echo ""
echo "✅ XONG! Kết quả lưu trong: output/$1/"
echo "👉 Tải file .elog về → mở bằng OMNeT++ IDE để xem animation!"
