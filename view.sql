create or replace view daftarPromoTerhubung as select pe.namaLengkap as `Nama Pengguna`,pe.level as `Level Pengguna`,
pr.nama as `Nama Promo`, pr.levelPengguna `Level Minimal Promo`, pr.minTransaksi as `Minimal Transaksi`
from promoTerhubung pt join pengguna pe join promo pr where pe.id = pt.idPengguna and pr.id = pt.idPromo;
select * from daftarPromoTerhubung;