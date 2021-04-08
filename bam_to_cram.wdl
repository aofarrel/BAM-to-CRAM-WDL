version 1.0

task cramify {
	input {
		File bam
		File ref
		File? refIndex
		String output_file_name = basename(sub(bam, "\.bam(?!.{1,})", ".cram"))
		# runtime attributes
		Int cpu
		Int disk
		Int memory
	}
	command {
		set -eux -o pipefail

		samtools view ${bam} -C -T ${ref}
	}
	runtime {
		cpu: cpu
		docker: "quay.io/cancercollaboratory/dockstore-tool-samtools-view:1.0"
		disks: "local-disk ${disk} SSD"
		memory: "${memory} GB"
	}
	output {
		File cram = output_file_name
	}
}

workflow bam_to_cram {
	input {
		Array[File] bams
		File ref
		File refIndex

		# runtime attributes
		Int cpu = 1
		Int disk = 5
		Int memory = 4
	}

	scatter(bam in bams) {
		call cramify {
			input:
				bam = bam,
				ref = ref,
				refIndex = refIndex,
				cpu = cpu,
				disk = disk,
				memory = memory
		}
	}

	meta {
		author: "Ash O'Farrell"
		email: "aofarrel@ucsc.edu"
	}
}