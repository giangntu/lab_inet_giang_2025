
---

# **LAB 1: GIAO TIẾP VÔ TUYẾN**

> *Dựa trên hướng dẫn gốc tại: https://inet.omnetpp.org/docs/tutorials/wireless/doc/step1.html*

---

## **1. MỤC ĐÍCH**

Tạo mạng gồm 2 host, một host gửi luồng dữ liệu UDP qua môi trường vô tuyến đến host kia. Sử dụng mô hình vật lý và giao thức đơn giản nhất để tập trung vào cấu trúc mô phỏng.

---

## **2. CẤU HÌNH GỐC (KẾ THỪA TỪ TUTORIAL)**

### **2.1. Topology**
- Kích thước sân chơi: **650m x 500m**.
- Vị trí: `hostA` tại **(50,325)**, `hostB` tại **(450,325)** → khoảng cách = **400m**.
- Module bắt buộc: `visualizer`, `configurator`, `radioMedium`.

### **2.2. File NED — Chỉ cần biết**
- **Không cần chỉnh sửa NED** ở bước này.
- Host được khai báo kiểu `WirelessHost`.
- Số liệu thống kê “packets received” được gắn vào `hostB.app[0].packetReceived`.

### **2.3. File omnetpp.ini — Các tham số CẦN BIẾT**

```ini
# THỜI GIAN MÔ PHỎNG
sim-time-limit = 20s

# ỨNG DỤNG
*.hostA.app[0].sendInterval = exponential(12ms)  # Khoảng cách gửi gói
*.hostA.app[0].messageLength = 1000B            # Kích thước payload
*.hostB.app[0].typename = "UdpSink"             # Host B chỉ nhận và đếm

# VÔ TUYẾN
*.host*.wlan[0].radio.transmitter.communicationRange = 500m
*.host*.wlan[0].radio.receiver.ignoreInterference = true
*.host*.**.bitrate = 1Mbps
*.host*.wlan[0].mac.headerLength = 23B          # Overhead MAC
```

---

## **3. LÝ THUYẾT & CÔNG THỨC TOÁN HỌC**

### **3.1. Mô hình Unit Disk (Đĩa đơn vị)**

Gói tin truyền thành công nếu:

\[
\boxed{d_{ij} \leq R_c}
\]

- \(d_{ij}\): Khoảng cách Euclid giữa thiết bị \(i\) và \(j\).
- \(R_c = 500\text{m}\): Phạm vi giao tiếp.

→ Trong bài lab, \(d_{AB} = 400\text{m} < 500\text{m}\) → **luôn thành công**.

### **3.2. Lưu lượng & Tốc độ truyền**

- **Tốc độ lý thuyết (payload)**:
  \[
  \lambda = \frac{1}{\text{E}[T]} = \frac{1}{0.012} \approx 83.33 \text{ gói/s}
  \]
  \[
  \text{Tốc độ payload} = \lambda \times L = 83.33 \times 1000 \text{B} \approx 83.33 \text{ kB/s} = \boxed{666.67 \text{ kbps}}
  \]

- **Tốc độ thực tế (có overhead)**:
  \[
  L_{\text{total}} = 1000\text{B} + 23\text{B} = 1023\text{B}
  \]
  \[
  \text{Tốc độ thực} = \frac{2017 \text{ gói} \times 1023 \text{B} \times 8}{20 \text{ s}} \approx \boxed{828.5 \text{ kbps}}
  \]

> 📊 *Kết quả mô phỏng gốc: 2017 gói sau 20s → khớp với lý thuyết.*

---

## **4. QUAN SÁT & PHÂN TÍCH**

1. **Trực quan hóa**: Số gói nhận được cập nhật real-time trên giao diện Qtenv.
2. **Luồng dữ liệu**: Gói đi từ `UdpBasicApp` → `UDP` → `IPv4` → `wlan[0]`.
3. **Hoạt ảnh truyền tin**: Mũi tên di chuyển từ `hostA` đến `hostB`.
4. **Kết quả**: ~2017 gói nhận được → **xác nhận mô hình hoạt động đúng**.

---

## **5. MỞ RỘNG & THỰC NGHIỆM**

### **5.1. Thay đổi vị trí hostB**
- **Thao tác**: Sửa `@display("p=...")` trong file `WirelessA.ned`.
- **Ví dụ**: `(600,325)` → khoảng cách = 550m > 500m.
- **Kết quả**: 0 gói → **xác nhận công thức \(d_{ij} \leq R_c\)**.

### **5.2. Tăng tốc độ gửi**
- **Thao tác**: Sửa `sendInterval = exponential(6ms)` trong `omnetpp.ini`.
- **Kết quả**: Số gói ~4000 → **tốc độ tăng gấp đôi**.

### **5.3. Bật can nhiễu**
- **Thao tác**: Sửa `ignoreInterference = false`.
- **Kết quả**: Số gói giảm → do xung đột nội tại trong mô hình Unit Disk.

### **5.4. Giảm bitrate**
- **Thao tác**: Sửa `bitrate = 512kbps`.
- **Công thức thời gian truyền**:
  \[
  T_{tx} = \frac{1023 \times 8}{512000} \approx 16\text{ms}
  \]
- **Quan sát**: Gói vẫn gửi mỗi ~12ms → **NIC tích lũy gói** → chưa tràn.

---

## **6. KẾT LUẬN**

Bài lab giúp sinh viên làm quen với cấu trúc mô phỏng INET, hiểu cách cấu hình qua `omnetpp.ini`, và định lượng hóa hành vi mạng bằng công thức toán học. Các thử nghiệm mở rộng giúp củng cố kiến thức về ảnh hưởng của khoảng cách, tốc độ gửi, và môi trường vật lý.
