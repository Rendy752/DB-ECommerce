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