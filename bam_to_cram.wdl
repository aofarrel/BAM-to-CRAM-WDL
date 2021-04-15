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
		
		bash_ref=${ref}
		if [[ $bash_ref == *.gz ]]
		then
			bash_unzipped=$(echo "${ref}" | rev | cut -c4- | rev)
			gzip -d -f -k ${ref}
			samtools view -C -T $bash_unzipped ${bam} > ${output_file_name}
		else
			samtools view -C -T ${ref} ${bam} > ${output_file_name}
		fi
	}
	runtime {
		cpu: cpu
		docker: "biowardrobe2/samtools:v1.11"
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
		File? refIndex

		# runtime attributes
		Int cpu = 8
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