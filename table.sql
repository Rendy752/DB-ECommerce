create database shop;
use shop;

call reset();
delimiter <>
create or replace procedure reset()
begin

drop table if exists promoterhubung;
drop table if exists detailpesanan;
drop table if exists pesananpelapak;
drop table if exists promopelapak;
drop table if exists keranjang;
drop table if exists kurir;
drop table if exists pesanan;
drop table if exists metodepembayaranterhubung;
drop table if exists promo;
drop table if exists produkfavorit;
drop table if exists produk;
drop table if exists kategori;
drop table if exists alamat;
drop table if exists pelapak;
drop table if exists pengguna;
drop table if exists metodePembayaran;

CREATE TABLE IF NOT EXISTS `shop`.`pengguna` (
  `id` CHAR(36) NOT NULL,
  `namaLengkap` VARCHAR(255) NOT NULL,
  `username` VARCHAR(255) NOT NULL,
  `noTelp` VARCHAR(20),
  `email` VARCHAR(255),
  `password` VARCHAR(255) NOT NULL,
  `pin` CHAR(4),
  `level` INT NOT NULL,
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
  `minTransaksi` DECIMAL(10,2) NOT NULL,
  `diskon` INT NOT NULL,
  `berlakuHingga` DATE NOT NULL,
  `levelPengguna` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`metodePembayaran` (
  `id` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`alamat` (
  `id` CHAR(36) NOT NULL,
  `idPengguna` CHAR(36) NOT NULL,
  `alamat` VARCHAR(255) NOT NULL,
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
    PRIMARY KEY(`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`metodePembayaranTerhubung` (
  `idPengguna` CHAR(36) NOT NULL,
  `idMetodePembayaran` CHAR(36) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPenggunaMetodePembayaran`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idMetodePembayaranTerhubung`
    FOREIGN KEY (`idMetodePembayaran`)
    REFERENCES `shop`.`metodePembayaran` (`id`)
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
  `rating` DOUBLE,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`promoPelapak` (
  `id` CHAR(36) NOT NULL,
  `idPelapak` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `deskripsi` VARCHAR(255) NOT NULL,
  `minTransaksi` DECIMAL(10,2) NOT NULL,
  `diskon` INT NOT NULL,
  `berlakuHingga` DATE NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY(`id`),
  CONSTRAINT `fk_idPelapakPromoPelapak`
    FOREIGN KEY (`idPelapak`)
    REFERENCES `shop`.`pelapak` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`produk` (
  `id` CHAR(36) NOT NULL,
  `idKategori` CHAR(36) NOT NULL,
  `idPelapak` CHAR(36) NOT NULL,
  `nama` VARCHAR(255) NOT NULL,
  `rating` DOUBLE,
  `ulasan` INT,
  `stok` INT NOT NULL,
  `terjual` INT,
  `kondisi` VARCHAR(255) NOT NULL,
  `berat` INT NOT NULL,
  `asal` VARCHAR(255) NOT NULL,
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

CREATE TABLE IF NOT EXISTS `shop`.`produkFavorit` (
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
  `idPromo` CHAR(36),
  `idAlamat` CHAR(36) NOT NULL,
  `idMetodePembayaran` CHAR(36) NOT NULL,
  `tanggal` DATE NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_idPenggunaPesanan`
    FOREIGN KEY (`idPengguna`)
    REFERENCES `shop`.`pengguna` (`id`),
  CONSTRAINT `fk_idPromoPesanan`
    FOREIGN KEY (`idPromo`)
    REFERENCES `shop`.`promo` (`id`),
    CONSTRAINT `fk_idAlamatPesanan`
    FOREIGN KEY (`idAlamat`)
    REFERENCES `shop`.`alamat` (`id`),
  CONSTRAINT `fk_idMetodePembayaranPesanan`
    FOREIGN KEY (`idMetodePembayaran`)
    REFERENCES `shop`.`metodePembayaran` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`kurir` (
  `id` CHAR(36) NOT NULL,
  `nama` CHAR(36) NOT NULL,
  `ongkir` DECIMAL(10,2) NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`pesananPelapak` (
  `id` CHAR(36) NOT NULL,
  `idPesanan` CHAR(36) NOT NULL,
  `idPelapak` CHAR(36) NOT NULL,
  `idKurir` CHAR(36) NOT NULL,
  `idPromoPelapak` CHAR(36),
  `status` VARCHAR(255) NOT NULL,
  `catatan` VARCHAR(255),
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_idPesananPesananPelapak`
    FOREIGN KEY (`idPesanan`)
    REFERENCES `shop`.`pesanan` (`id`),
  CONSTRAINT `fk_idPelapakPesananPelapak`
    FOREIGN KEY (`idPelapak`)
    REFERENCES `shop`.`pelapak` (`id`),
  CONSTRAINT `fk_idKurirPesananPelapak`
    FOREIGN KEY (`idKurir`)
    REFERENCES `shop`.`kurir` (`id`),
  CONSTRAINT `fk_idPromoPelapakPesananPelapak`
    FOREIGN KEY (`idPromoPelapak`)
    REFERENCES `shop`.`promoPelapak` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `shop`.`detailPesanan` (
  `idPesananPelapak` CHAR(36) NOT NULL,
  `idProduk` CHAR(36) NOT NULL,
  `jumlah` INT NOT NULL,
  `createdAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_idPesananPelapakDetailPesanan`
    FOREIGN KEY (`idPesananPelapak`)
    REFERENCES `shop`.`pesananPelapak` (`id`),
  CONSTRAINT `fk_idProdukPesanan`
    FOREIGN KEY (`idProduk`)
    REFERENCES `shop`.`produk` (`id`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

end <>
delimiter ;

call reset();