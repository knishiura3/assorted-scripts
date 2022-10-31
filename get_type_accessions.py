import pandas as pd
import datetime
from urllib import request


def get_type_speciesID_from_assembly_summary(group):
    url = f"https://ftp.ncbi.nlm.nih.gov/genomes/refseq/{group}/assembly_summary.txt"
    request.urlretrieve(url, f"assembly_summary_{group}.txt")
    df = pd.read_csv(f"assembly_summary_{group}.txt", sep="\t", header=1, dtype=str)
    accession = df.keys()[0]
    species_taxid = df.keys()[6]
    type_mat_status = df.keys()[21]
    # exclude all species IDs that have nan in the type_material column since they do not have a type representative in refseq
    type_representative = df[type_mat_status].dropna()
    # get all species_taxids that have a type representative in refseq
    type_material_speciesIDs = df[df[type_mat_status].isin(type_representative)][
        species_taxid
    ].unique()
    # get all accessions and matching species_taxid where the species_taxid are in the type_material_speciesIDs

    type_material_accs_and_speciesIDs = df[
        df[species_taxid].isin(type_material_speciesIDs)
    ][
        [
            species_taxid,
            accession,
        ]
    ].drop_duplicates()

    return type_material_accs_and_speciesIDs


def main():
    bacteria_type_accessions = get_type_speciesID_from_assembly_summary("bacteria")
    print(len(bacteria_type_accessions))
    archaea_type_accessions = get_type_speciesID_from_assembly_summary("archaea")
    print(len(archaea_type_accessions))
    # write all type material accessions to a file using list comprehension

    # for both bacteria and archaea, group by species_taxid and output all accessions on separate lines for each species_taxid to file
    for group in [bacteria_type_accessions, archaea_type_accessions]:
        for species_taxid, group in group.groupby("species_taxid"):
            # get the subset of group where the taxid matches current species_taxid
            group[group["species_taxid"] == species_taxid][
                "# assembly_accession"
            ].to_csv(
                f"assembly_lists/{species_taxid}.tsv",
                sep="\t",
                header=False,
                index=False,
                mode="w",
            )


if __name__ == "__main__":
    main()
