create database shop;
use shop;

call reset();
delimiter <>
create or replace procedure reset()
begin

drop table if exists promoterhubung;
drop table if exists keranjang;
drop table if exists pesanan;
drop table if exists dompetterhubung;
drop table if exists promo;
drop table if exists barangfavorit;
drop table if exists produk;
drop table if exists kategori;
drop table if exists alamat;
drop table if exists pelapak;
drop table if exists pengguna;
drop table if exists dompetdigital;

CREATE TABLE IF NOT EXISTS `shop`.`pengguna` (
  `id` CHAR(36) NOT NULL,
  `namaLengkap` VARCHAR(255) NOT NULL,
  `noTelp` VARCHAR(20) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `otp` CHAR(36),
  `pin` CHAR(36),
  `status` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`kategori` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`promo` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `deskripsi` VARCHAR(255) NOT NULL,
  `jenis` VARCHAR(255) NOT NULL,
  `minTransaksi` DECIMAL(10,2) NOT NULL,
  `status` VARCHAR(255) NOT NULL,
  `statusPengguna` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`dompetDigital` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`alamat` (
  `idPengguna` CHAR(36) NOT NULL,
  `idDompet` CHAR(36) NOT NULL,
  `alamatLengkap` VARCHAR(255) NOT NULL,
  `alamatSebagai` ENUM('rumah','apartemen','kantor','lainnya'),
  `namaPenerima` VARCHAR(255) NOT NULL,
  `noTelp` VARCHAR(20) NOT NULL,
  `kecamatan` VARCHAR(255) NOT NULL,
  `kota` VARCHAR(255) NOT NULL,
  `provinsi` VARCHAR(255) NOT NULL,
  `kodePos` INT(5) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPengguna`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idDompet`
    FOREIGN KEY (`idDompet`)
    REFERENCES `shop`.`dompetDigital` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`dompetTerhubung` (
  `idPengguna` CHAR(36) NOT NULL,
  `idDompet` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaDompet`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idDompetTerhubung`
    FOREIGN KEY (`idDompet`)
    REFERENCES `shop`.`dompetDigital` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`promoTerhubung` (
  `idPengguna` CHAR(36) NOT NULL,
  `idPromo` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaPromo`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idPromoTerhubung`
    FOREIGN KEY (`idPromo`)
    REFERENCES `shop`.`promo` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`pelapak` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `lokasi` VARCHAR(20) NOT NULL,
  `feedbackPositif` VARCHAR(255) NOT NULL,
  `waktuProsesTercepat` INT NOT NULL,
  `waktuProsesTerlama` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`produk` (
  `id` CHAR(36) NOT NULL,
  `idKategori` CHAR(36) NOT NULL,
  `idPelapak` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `rating` DOUBLE NOT NULL,
  `ulasan` INT NOT NULL,
  `stok` INT NOT NULL,
  `terjual` INT NOT NULL,
  `kondisi` ENUM('baru', 'lama', 'bekas'),
  `berat` INT NOT NULL,
  `asal` ENUM('lokal','impor'),
  `deskripsi` TEXT NOT NULL,
  `harga` DECIMAL(10,2) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_idKategoriProduk`
    FOREIGN KEY (`idKategori`)
    REFERENCES `shop`.`kategori` (`id`),
  CONSTRAINT `fk_idPelapakProduk`
    FOREIGN KEY (`idPelapak`)
    REFERENCES `shop`.`pelapak` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`barangFavorit` (
  `idPengguna` CHAR(36) NOT NULL,
  `idProduk` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaFavorit`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idProdukFavorit`
    FOREIGN KEY (`idProduk`)
    REFERENCES `shop`.`produk` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`keranjang` (
  `idPengguna` CHAR(36) NOT NULL,
  `idProduk` CHAR(36) NOT NULL,
  `jumlah` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaKeranjang`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idProdukKeranjang`
    FOREIGN KEY (`idProduk`)
    REFERENCES `shop`.`produk` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`pesanan` (
  `id` CHAR(36) NOT NULL,
  `idPengguna` CHAR(36) NOT NULL,
  `idPelapak` CHAR(36) NOT NULL,
  `idPromo` CHAR(36) NOT NULL,
  `idDompet` CHAR(36) NOT NULL,
  `tanggal` DATE NOT NULL,
  `catatan` VARCHAR(255),
  `status` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_idPenggunaPesanan`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idPelapakPesanan`
    FOREIGN KEY (`idPelapak`)
    REFERENCES `shop`.`pelapak` (`id`),
  CONSTRAINT `fk_idPromoPesanan`
    FOREIGN KEY (`idPromo`)
    REFERENCES `shop`.`promo` (`id`),
  CONSTRAINT `fk_idDompetPesanan`
    FOREIGN KEY (`idDompet`)
    REFERENCES `shop`.`dompetDigital` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- Table pengguna
INSERT INTO `shop`.`pengguna` (`id`, `namaLengkap`, `noTelp`, `email`, `password`, `otp`, `pin`, `status`) 
-- Dummy 1
VALUES (UUID(), 'Ilham', '08129022310', 'ilham@gmail.com', password('ilham7580'),'0012', '7580', 'aktif'),
-- Dummy 2
(UUID(), 'Cita', '087638172311', 'cita12@gmail.com', password('cita123'),'0012', '1234', 'aktif'),
-- Dummy 3
(UUID(), 'Laura', '085367818912', 'Laura22@gmail.com', password('laura2233'),'0012', '2233', 'tidak aktif'),
-- Dummy 4
(UUID(), 'Windah', '085378908716', 'Windahgeming@gmail.com', password('windah4444'),'0012', '4444', 'aktif'),
-- Dummy 5
(UUID(), 'Basudara', '085379809112', 'basudarageming@gmail.com', password('basudara8989'),'0012', '8989', 'aktif');


-- Table kategori
INSERT INTO `shop`.`kategori` (`id`, `nama`)
-- Dummy 1
VALUES (UUID(), 'Elektronik'),
-- Dummy 2
(UUID(), 'Fashion'),
-- Dummy 3
(UUID(), 'Perfume'),
-- Dummy 4
(UUID(), 'Accesories'),
-- Dummy 5
(UUID(), 'Alat Dapur');


-- Table promo
INSERT INTO `shop`.`promo` (`id`, `nama`, `deskripsi`, `jenis`, `minTransaksi`, `status`, `statusPengguna`)
-- Dummy 1
VALUES (UUID(), 'Promo Lebaran', 'Diskon 20% untuk semua produk', 'diskon', 100000, 'aktif', 'semua'),
-- Dummy 2
(UUID(), 'Promo Natal', 'Diskon 10% untuk semua produk', 'diskon', 200000, 'aktif', 'semua'),
-- Dummy 3
(UUID(), 'Promo 6.6', 'Diskon 20% untuk semua produk', 'diskon', 400000, 'aktif', 'semua'),
-- Dummy 4
(UUID(), 'Promo Potongan', 'Diskon 10% Potongan Untuk Produk Yang Dpilih', 'diskon', 0, 'aktif', 'semua'),
-- Dummy 5
(UUID(), 'Promo Tahun Baru', 'Diskon 40% untuk semua produk', 'diskon', 200000, 'Tidak Aktif', 'semua');


-- Table dompetDigital
INSERT INTO `shop`.`dompetDigital` (`id`, `nama`)
-- Dummy 1
VALUES (UUID(), 'OVO'),
-- Dummy 2
(UUID(), 'BCA'),
-- Dummy 3
(UUID(), 'GoPay'),
-- Dummy 4
(UUID(), 'ShopeePay'),
-- Dummy 5
(UUID(), 'DANA');


-- Table alamat
INSERT INTO `shop`.`alamat` (`idPengguna`, `idDompet`, `alamatLengkap`, `alamatSebagai`, `namaPenerima`, `noTelp`, `kecamatan`, `kota`, `provinsi`, `kodePos`)
-- Dummy 1
SELECT
(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Ilham') AS idPengguna,
(SELECT id FROM shop.dompetDigital WHERE nama = 'OVO') AS idDompet,
'Jl. Rambutan No. 123', 'rumah', 'Ilham', '08129022310', 'Kec. Rambutan', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32511
UNION ALL
-- Dummy 2
SELECT
(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Cita') AS idPengguna,
(SELECT id FROM shop.dompetDigital WHERE nama = 'ShopeePay') AS idDompet,
'Jl. Mangga No. 456', 'kantor', 'Cita', '087638172311', 'Kec. Mangga', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32512
UNION ALL
-- Dummy 3
SELECT
(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Laura') AS idPengguna,
(SELECT id FROM shop.dompetDigital WHERE nama = 'DANA') AS idDompet,
'Jl. Apel No. 789', 'rumah', 'Laura', '085367818912', 'Kec. Apel', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32513
UNION ALL
-- Dummy 4
SELECT
(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Windah') AS idPengguna,
(SELECT id FROM shop.dompetDigital WHERE nama = 'DANA') AS idDompet,
'Jl. Jeruk No. 101', 'rumah', 'Windah', '085378908716', 'Kec. Jeruk', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32514
UNION ALL
-- Dummy 5
SELECT
(SELECT id FROM shop.pengguna WHERE namaLengkap = 'Basudara') AS idPengguna,
(SELECT id FROM shop.dompetDigital WHERE nama = 'OVO') AS idDompet,
'Jl. Manggis No. 202', 'rumah', 'Basudara', '085379809112', 'Kec. Manggis', 'Kota Palembang', 'Provinsi Sumatera Selatan', 32515;
  

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


-- TABLE PROMOTERHUBUNG
-- Dummy 1
INSERT INTO `shop`.`promoTerhubung` (`idPengguna`, `idPromo`)
 SELECT
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Ilham") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Lebaran" ) AS idPromo
-- Dummy 2
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Cita") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo 6.6" ) AS idPromo
-- Dummy 3
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Laura") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Natal" ) AS idPromo
-- Dummy 4
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Windah") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Potongan" ) AS idPromo
-- Dummy 5
UNION ALL
 SELECT 
 (SELECT id FROM shop.pengguna WHERE namaLengkap = "Basudara") AS idPengguna,
 (SELECT id FROM shop.promo WHERE nama = "Promo Tahun Baru" ) AS idPromo;


-- Table pelapak
INSERT INTO `shop`.`pelapak` (`id`, `nama`, `lokasi`, `feedbackPositif`, `waktuProsesTercepat`, `waktuProsesTerlama`) 
-- Dummy 1
VALUES 
(UUID(), 'Asus Official', 'Jakarta', 'positif', 2, 5),
-- Dummy 2
(UUID(), 'Zara', 'Bandung', 'positif', 1, 3), 
 -- Dummy 3
(UUID(), 'Indonesia Merk', 'Jakarta', 'positif', 3, 5),
-- Dummy 4
(UUID(), 'Xyz Shop', 'Bandung', 'negatif', 20, 24), 
 -- Dummy 5
(UUID(), 'H&M', 'Jakarta', 'positif', 1, 2),
 -- Dummy 6
(UUID(), 'Gucci', 'Kalimantan', 'positif', 1, 3),
 -- Dummy 7
(UUID(), 'Sonny Official', 'Jakarta', 'positif', 2, 4),
-- Dummy 8
(UUID(), 'Samsung Official', 'Jakarta', 'negatif', 1, 3),
 -- Dummy 9
(UUID(), 'Nike', 'Jakarta', 'negatif', 1, 6);


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
INSERT INTO `shop`.`pesanan` (`id`, `idPengguna`, `idPelapak`, `idPromo`, `idDompet`, `tanggal`, `catatan`, `status`)
VALUES (uuid_short(), 
(SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Ilham"),
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Asus Official"), 
(SELECT `id` FROM `shop`.`promo` WHERE nama = "Promo Lebaran"),
 (SELECT `id` FROM `shop`.`dompetDigital` WHERE nama = "OVO" ), 
 '2023-06-06', ' ', 'proses');
 
--  Dummy 2
INSERT INTO `shop`.`pesanan` (`id`, `idPengguna`, `idPelapak`, `idPromo`, `idDompet`, `tanggal`, `catatan`, `status`)
VALUES (uuid_short(), 
(SELECT `id` FROM `shop`.`pengguna`  WHERE namaLengkap = "Cita"), 
(SELECT `id` FROM `shop`.`pelapak` WHERE nama = "Zara"), 
(SELECT `id` FROM `shop`.`promo` WHERE nama = "Promo 6.6"),
 (SELECT `id` FROM `shop`.`dompetDigital` WHERE nama = "OVO" ), 
 '2023-06-06', ' ', 'proses');
 
 end <>
 delimiter ;


INSERT INTO `shop`.`pengguna` (`id`, `namaLengkap`, `noTelp`, `email`, `password`, `otp`, `pin`, `status`) VALUES 
(UUID(), 'Ilham', '08129022310', 'ilham@gmail.com', password('ilham7580'),'0012', '7580', 'aktif'),
(UUID(), 'Cita', '087638172311', 'cita12@gmail.com', password('cita123'),'0012', '1234', 'aktif'),
(UUID(), 'Laura', '085367818912', 'Laura22@gmail.com', password('laura2233'),'0012', '2233', 'tidak aktif'),
(UUID(), 'Windah', '085378908716', 'Windahgeming@gmail.com', password('windah4444'),'0012', '4444', 'aktif'),
(UUID(), 'Basudara', '085379809112', 'basudarageming@gmail.com', password('basudara8989'),'0012', '8989', 'aktif');


select *from pengguna;
select *from dompetdigital;
select *from alamat;
select *from dompetterhubung;
select *from keranjang;
select *from pelapak;
select *from produk;
select *from promo;
select *from promoterhubung;
select *from kategori;
select *from pesanan;
