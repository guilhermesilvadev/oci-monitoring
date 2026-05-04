variable "tenancy_ocid" {
  type        = string
  description = "The ocid of the current tenancy."
  default     = "ocid1.tenancy.oc1..aaaaaaaa6oh32pfi67sr3squa2i7gcnuhjmjquqwlx5e6z37y3y6x5smpdkq"
}

variable "instance_image_ocid" {
  type = map(string)
  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    af-johannesburg-1 = "ocid1.image.oc1.af-johannesburg-1.aaaaaaaaqdpqqlmx6cnbb5epnw5zg3unfygcnj7vnnfx44qxgtob7j6jkida"
    us-chicago-1 = "ocid1.image.oc1.us-chicago-1.aaaaaaaaw4cggpn2wh4jhwpkcjdzvyicfaqblwcc6xq5k4i2jxkg2bx4gm6a"
    ap-melbourne-1 = "ocid1.image.oc1.ap-melbourne-1.aaaaaaaa452osj6b5o3ugn3a6bhpj2gkcfldonfdt34hbi34unqj6wq2efeq"
    uk-london-1 = "ocid1.image.oc1.uk-london-1.aaaaaaaap4rls4ov3txexs4s3jo7mzhlbd5lb5tgix5ruced5kdpn6ga2ziq"
    sa-vinhedo-1 = "ocid1.image.oc1.sa-vinhedo-1.aaaaaaaad5akqduduuepzmuzlsz3q4fn3lcmaes6srfgghb27wpavhx7lweq"
    mx-monterrey-1 = "ocid1.image.oc1.mx-monterrey-1.aaaaaaaaztlpxdsma4lydewgz6balbktv32yaplhbq4dxk3fne73anw3rqoq"
    me-dubai-1 = "ocid1.image.oc1.me-dubai-1.aaaaaaaaf5gjvrmx7q22ljz7uf22f5zkxozzdj3pasbkb4akaqsmwgjwpeiq"
    eu-stockholm-1 = "ocid1.image.oc1.eu-stockholm-1.aaaaaaaaaoyihdl25asihzlvnqn7iluims56x7giogsze7eupypdzezpkcna"
    eu-marseille-1 = "ocid1.image.oc1.eu-marseille-1.aaaaaaaavdmffyo7oo52zyb3aj6v6ypi5stzst3ibpay5glpvnhqjbguzqva"
    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaaew4bboppacmw7pvlog5wvtygfxhrvv2bfanicvjj2ljrmvtkfdtq"
    ca-montreal-1 = "ocid1.image.oc1.ca-montreal-1.aaaaaaaaokvcf2uuidul5n7ukneihfkrtrowlyoo22ceowanplkinmbftmca"
    ap-hyderabad-1 = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaaz2glfsxaks4mvrnx5dpcevkm4yo32bls4zkfg7brsklldwgtq2oq"
    eu-madrid-1 = "ocid1.image.oc1.eu-madrid-1.aaaaaaaar753tkdhpr5psyqp757ywxcopxsrp63f5madr63qvfcnpl4gmvpq"
    me-abudhabi-1 = "ocid1.image.oc1.me-abudhabi-1.aaaaaaaa6poj546tz2cijsosdk2k7yv2nz5nniqyosmjuuid4ddqco2kys5q"
    ca-toronto-1 = "ocid1.image.oc1.ca-toronto-1.aaaaaaaa7cuflxmluvu7lumzlz2lcrvhh7seamwsrpyvjfey2ed25pxw5lha"
    ap-seoul-1 = "ocid1.image.oc1.ap-seoul-1.aaaaaaaa3ggmkhzgz3hplw2zmtuwcdtaycgnzguqnledgbgp5hdwp6446wna"
    eu-amsterdam-1 = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaapzka752zjqzcc6izyb76nuoykjacst3vh3ajk5gx7rtv3fs77nnq"
    ap-singapore-1 = "ocid1.image.oc1.ap-singapore-1.aaaaaaaagprtf6o4mbujj5mnvkexld4o2yzelslvakisyn3xzgnlvterx5yq"
    ap-chuncheon-1 = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaa2aba3mdaecijziy7mwu3tlywkuhfpjg2cqrppymnilsi6dmi5b6a"
    eu-milan-1 = "ocid1.image.oc1.eu-milan-1.aaaaaaaaeas76yozgzazql2jnmhj6kobn5ts6ww4bc4xef6ds3v6ramqhscq"
    us-sanjose-1 = "ocid1.image.oc1.us-sanjose-1.aaaaaaaakb25v43zvj44zljk73p2j5e2ew2ycht5obleuy7ntj24pttc65ga"
    il-jerusalem-1 = "ocid1.image.oc1.il-jerusalem-1.aaaaaaaaeeuxd7ude5zni4dqwozli7a536mhektykur6uviecuk2o4tsrklq"
    mx-queretaro-1 = "ocid1.image.oc1.mx-queretaro-1.aaaaaaaalrf6t3gniugo43vpng35fc7hxnsrcebdxzsqtngjsrxj6fpvctuq"
    uk-cardiff-1 = "ocid1.image.oc1.uk-cardiff-1.aaaaaaaa6oqe47otk7hhflzoi5c54ymtux22yah5i5k57tbr3kj7k5nfp5ja"
    sa-santiago-1 = "ocid1.image.oc1.sa-santiago-1.aaaaaaaa4rq22p36myj34fgphvwgdpeccvvutgzaxweqeijke7chh4myxg4q"
    ap-osaka-1 = "ocid1.image.oc1.ap-osaka-1.aaaaaaaa6m7p5iazaehmgsgslipr6zuptqgm22tiam247w777wyyr2x5fvyq"
    ap-mumbai-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaxtpiye5nnlmdl4a4far26ywp4mw3xtuchg6texgrlrl435mgomaq"
    sa-saopaulo-1 = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaaxcphxaxuvggls4i25h5y237mztgqcnu5tzzohwblqpuwujmegqhq"
    eu-paris-1 = "ocid1.image.oc1.eu-paris-1.aaaaaaaa6xlbmoowll7hlnguxerfneqoqu7xkqo326s5zwxigtka6u7gbyyq"
    ap-sydney-1 = "ocid1.image.oc1.ap-sydney-1.aaaaaaaaqhduu7nfiykttv3xkfb5wopizfjhw4zionfbkcm5cvwv6lmge56q"
    me-jeddah-1 = "ocid1.image.oc1.me-jeddah-1.aaaaaaaaor7hh5ab366iiju6mvdx7e63vyh2l2gr5l4betkueqibx7cieciq"
    sa-valparaiso-1 = "ocid1.image.oc1.sa-valparaiso-1.aaaaaaaa2zisjez3t47pn223kt75hi4lyal7hwiu5d7y5evmwwh7hdivjwnq"
    sa-bogota-1 = "ocid1.image.oc1.sa-bogota-1.aaaaaaaacpe45o3yrbe2k3da4ojiuvvga4sfamspawiaddvkpf4yhfat3xoa"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaabp5nsbzluz7iwrjiy43nuv4etwd5daznf4u7jdfktlqh66ww3lzq"
    eu-zurich-1 = "ocid1.image.oc1.eu-zurich-1.aaaaaaaacm6emgg7isp4jtgmd43ydhzikk7dh52msw4pdbsrn5amogidoc7a"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaatvm5xr23xsvjofwybmqfixrsfk4442sjpckjccechfhqso5kt4ia"
    ap-tokyo-1 = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaalkl63v2t2n52u3jgon2i3lsqzf5hecztzgqlasm6djuzgedf2eaa"
  }
}