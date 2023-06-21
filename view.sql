create or replace view daftarPromoTerhubung as select pe.namaLengkap as `Nama Pengguna`,pe.level as `Level Pengguna`,
pr.nama as `Nama Promo`, pr.levelPengguna `Level Minimal Promo`, pr.minTransaksi as `Minimal Transaksi`
from promoTerhubung pt join pengguna pe join promo pr where pe.id = pt.idPengguna and pr.id = pt.idPromo;
select * from daftarPromoTerhubung;

create or replace view top3ProdukFavorit as select produk.nama as `Nama Produk`,pelapak.nama as `Nama Pelapak`,count(idProduk) as `Jumlah`
from produk join pelapak join produkFavorit where produk.idPelapak = pelapak.id and produkFavorit.idProduk = produk.id 
group by produk.nama order by count(idProduk) desc limit 3;
select*from top3ProdukFavorit;

create or replace view lihatSemuaPesanan as select pesanan.id as `No. Pesanan`,pesanan.tanggal as `Tanggal Pemesanan`,
date(tanggal+8) as `Estimasi Sampai`,alamat.namaPenerima as `Nama Penerima`,
concat(alamat,', ',kecamatan,', ',kota,'. ',provinsi,', ',kodePos,'.') as `Alamat`,alamat.noTelp as `No. Telp`,
metodePembayaran.nama as `Metode Pembayaran`,sum(detailPesanan.jumlah*produk.harga) as `Total Harga Barang`,
concat('Rp',round(substring_index(coalesce(sum((detailPesanan.jumlah*produk.harga))*(promo.diskon/100),0),'.',2),2)) as `Potongan Extra`,
sum(kurir.ongkir) as `Ongkos Kirim`,concat('Rp',round(coalesce(sum((detailPesanan.jumlah*produk.harga)-((detailPesanan.jumlah*produk.harga)*
(promo.diskon/100))+kurir.ongkir),sum(detailPesanan.jumlah*produk.harga)+sum(kurir.ongkir)),2)) as `Jumlah Bayar`, 
pesanan.tanggal as `Tanggal` from pesanan left join pesananPelapak on pesananPelapak.idPesanan=pesanan.id join detailPesanan 
on detailPesanan.idPesananPelapak=pesananPelapak.id join produk on detailPesanan.idProduk=produk.id join pengguna 
on pesanan.idPengguna=pengguna.id left join promo on pesanan.idPromo=promo.id join kurir on kurir.id=pesananPelapak.idKurir
join alamat on pesanan.idAlamat=alamat.id join metodePembayaran on metodePembayaran.id=pesanan.idMetodePembayaran 
group by pesanan.id order by pesanan.tanggal asc;
select*from lihatSemuaPesanan;

create or replace view lihatSemuaPesananProduk as select produk.nama as `Nama Produk`,alamat.namaPenerima as `Nama Penerima`,
detailPesanan.jumlah as `Jumlah`, detailPesanan.jumlah*produk.Harga as `Total`,pesanan.tanggal as `Tanggal`
from detailPesanan left join pesananPelapak on detailPesanan.idPesananPelapak=pesananPelapak.id join pesanan 
on pesananPelapak.idPesanan=pesanan.id join produk on detailPesanan.idProduk=produk.id join pengguna 
on pesanan.idPengguna=pengguna.id join alamat on pesanan.idAlamat=alamat.id order by pesanan.tanggal asc;
select*from lihatSemuaPesananProduk;

create or replace view top3ProdukTerlaris as select produk.nama as `Nama Produk`,pelapak.nama as `Nama Pelapak`,
sum(detailPesanan.jumlah*produk.Harga) as `Penjualan`
from detailPesanan left join produk on detailPesanan.idProduk=produk.id join pelapak on produk.idPelapak = pelapak.id
group by produk.id order by sum(detailPesanan.jumlah*produk.Harga) desc limit 3;
select*from top3ProdukTerlaris;