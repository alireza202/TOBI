removing_features = function(mt) {
    mt$indel = NULL
    mt$is_1 = NULL
    mt$is_2 = NULL
    mt$common = NULL
    mt$g5 = NULL
    mt$g5a = NULL
    mt$nov = NULL
    mt$meganormal_id = NULL
    mt$vp = NULL
    mt$transcript_id = NULL
    mt$mut = NULL
    mt$mtp = NULL
    mt$nsf = NULL
    mt$tpa = NULL
    mt$kgvalidated = NULL
    mt$oth = NULL
    mt$nmutperid = NULL
    mt$dbNSFP_1000Gp1_AC = NULL
    mt$dbNSFP_1000Gp1_AFR_AC = NULL
    mt$dbNSFP_1000Gp1_AMR_AC = NULL
    mt$dbNSFP_1000Gp1_ASN_AC = NULL
    mt$dbNSFP_1000Gp1_EUR_AC = NULL
    mt$dbNSFP_1000Gp1_ASN_AF = NULL
    mt$dbNSFP_1000Gp1_AFR_AF = NULL
    mt$dbNSFP_1000Gp1_AMR_AF = NULL
    mt$dbNSFP_1000Gp1_EUR_AF = NULL
    mt$dbNSFP_SiPhy_29way_pi = NULL
    mt$dbNSFP_1000Gp1_AF = NULL
    mt$dbNSFP_CADD_raw = NULL
    mt$dbNSFP_CADD_raw_rankscore = NULL
    mt$dbNSFP_UniSNP_ids = NULL
    mt$dbSNPBuildID = NULL
    mt$filter = NULL
    mt$an = NULL
    mt$aa = NULL
    mt$ac = NULL
    mt$af1 = NULL
    mt$asp = NULL
    mt$ass = NULL
    mt$caf = NULL
    mt$cda = NULL
    mt$cds = NULL
    mt$cfl = NULL
    mt$cgt = NULL
    mt$clnacc = NULL
    mt$clndsdb = NULL
    mt$clndsdbid = NULL
    mt$clnhgvs = NULL
    mt$clnsrc = NULL
    mt$clnsrcid = NULL
    mt$clr = NULL
    mt$dss = NULL
    mt$genotype_number = NULL
    mt$g3 = NULL
    mt$geneinfo = NULL
    mt$gene = NULL
    mt$hwe = NULL
    mt$indel.1 = NULL
    mt$lof = NULL
    mt$mdv = NULL
    mt$nmd = NULL
    mt$noc = NULL
    mt$nsn = NULL
    mt$om = NULL
    mt$pc2 = NULL
    mt$pchi2 = NULL
    mt$pmc = NULL
    mt$pr = NULL
    mt$qbd = NULL
    mt$qchi2 = NULL
    mt$r3 = NULL
    mt$rs = NULL
    mt$rspos = NULL
    mt$strand = NULL
    mt$u3 = NULL
    mt$u5 = NULL
    mt$ugt = NULL
    mt$wtd = NULL
    mt = mt[, -grep("*rankscore*", colnames(mt))]
    mt = mt[, -grep("*pred*", colnames(mt))]
    mt = mt[, -grep("*cln*", colnames(mt))]
    mt$ID = NULL
    mt$pl_1 = NULL
    mt$X = NULL
    mt$X.1 = NULL
    mt
}