-- Table dompetTerhubung
INSERT INTO `shop`.`dompetTerhubung` (`idPengguna`, `idDompet`)
-- Dummy 1
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Ilham") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "OVO")AS idDompet
UNION ALL 
-- Dummy 2
SELECT
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Cita") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "GoPay")AS idDompet
-- Dummy 3
UNION ALL
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Laura") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "BCA")AS idDompet 
UNION ALL
-- Dummy 4
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Windah") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "OVO")AS idDompet
-- Dummy 5
UNION ALL
SELECT 
(SELECT id FROM shop.pengguna WHERE namaLengkap = "Basudara") AS idPengguna,
(SELECT id From shop.dompetDigital WHERE nama = "OVO")AS idDompet ;


-- Table produk
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
-- Dummy 1
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Elektronik" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Asus Official"), 
'Laptop Asus ZenForce', 4.5, 10, 20, 5, 'baru', 2, 'lokal', 'Laptop Asus Zenforce Ram 12GB', 5000000);
-- Dummy 2
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Fashion" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Zara"), 
'Kemeja Denim', 4.2, 8, 50, 15, 'baru', 0.5, 'lokal', 'Kemeja Denim Pria Ukuran M', 350000);
-- Dummy 3
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Fashion" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "H&M"), 
'Celana Jeans Slim Fit', 4.0, 6, 40, 12, 'baru', 0.7, 'lokal', 'Celana Jeans Slim Fit Warna Biru', 250000);
-- Dummy 4
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Fashion" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Nike"), 
'Sepatu Nike Running', 4.5, 18, 45, 10, 'baru', 0.6, 'impor', 'Sepatu Nike Running Pria', 800000);
-- Dummy 5
INSERT INTO `shop`.`produk` (`id`, `idKategori`, `idPelapak`, `nama`, `rating`, `ulasan`, `stok`, `terjual`, `kondisi`, `berat`, `asal`, `deskripsi`, `harga`)
VALUES (UUID(),
(SELECT `id` FROM `shop`.`kategori` WHERE nama = "Elektronik" ), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Sonny Official"), 
'Headphone Sony', 4.6, 12, 25, 8, 'baru', 0.4, 'impor', 'Headphone Sony Noise-Canceling', 1200000);


-- Table barangFavorit
INSERT INTO `shop`.`barangFavorit` (`idPengguna`, `idProduk`)
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Ilham"),
 (SELECT id FROM shop.produk WHERE nama = "Headphone Sony" );
 

-- Table keranjang
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 1
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Ilham" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Laptop Asus ZenForce") AS idProduk, 1;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 2
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Cita" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Kemeja Denim") AS idProduk, 3;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 3
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Laura" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Celana Jeans Slim Fit") AS idProduk, 2;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 4
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Windah" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Sepatu Nike Running") AS idProduk, 4;
INSERT INTO `shop`.`keranjang` (`idPengguna`, `idProduk`, `jumlah`)
-- Dummy 5
SELECT
(SELECT `id` FROM `shop`.`pengguna` WHERE namaLengkap = "Basudara" ) AS idPengguna,
(SELECT `id` FROM `shop`.`produk` WHERE nama = "Headphone Sony") AS idProduk, 1;


-- Table pesanan
--  Dummy 1
INSERT INTO `shop`.`pesanan` (`id`, `idPengguna`, `idPelapak`, `idPromo`, `idAlamat`, `idDompet`, `tanggal`, `catatan`, `status`)
VALUES (uuid_short(), 
(SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Ilham"),
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Asus Official"), 
(SELECT `id` FROM `shop`.`promo` WHERE nama = "Promo Lebaran"),
(SELECT `id` FROM `shop`.`alamat` WHERE kodePos='32511'),
 (SELECT `id` FROM `shop`.`dompetDigital` WHERE nama = "OVO" ), 
 '2023-06-06', ' ', 'proses');
 
--  Dummy 2
INSERT INTO `shop`.`pesanan` (`id`, `idPengguna`, `idPelapak`, `idPromo`, `idAlamat`, `idDompet`, `tanggal`, `catatan`, `status`)
VALUES (uuid_short(),
(SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Cita"), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Zara"), 
(SELECT `id` FROM `shop`.`promo` WHERE nama = "Promo 6.6"),
(SELECT `id` FROM `shop`.`alamat` WHERE kodePos='32511'),
 (SELECT `id` FROM `shop`.`dompetDigital` WHERE nama = "OVO" ), 
 '2023-06-06', ' ', 'proses');
 
 -- Table detailpesanan
 --  Dummy 1
INSERT INTO `shop`.`detailpesanan` (`idPesanan`, `idProduk`) values
((SELECT `id` FROM `shop`.`pesanan`  WHERE idpengguna = (SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Cita")),
(SELECT `id` FROM `shop`.`produk`  WHERE nama = "Laptop Asus ZenForce"));

 --  Dummy 1

INSERT INTO `shop`.`detailpesanan` (`idPesanan`, `idProduk`) values
((SELECT `id` FROM `shop`.`pesanan`  WHERE idpengguna = (SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Ilham")),
(SELECT `id` FROM `shop`.`produk`  WHERE nama = "Kemeja Denim"));