# BAM to CRAM WDL
 Converts a BAM into a SAM file. You need to specify a reference genome in FASTA format. The reference genome can be gz compressed.

 This repo doesn't contain any ref files due to their size; you'll need to already have them.

 `dockstore workflow launch --local-entry bam_to_cram.wdl --json local.json`

 When using on Terra, use either gcs.json or gcs_downsample.json