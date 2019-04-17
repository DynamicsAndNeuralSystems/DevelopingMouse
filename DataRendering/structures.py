from allensdk.api.queries.rma_api import RmaApi
import pandas as pd
import os

def main():
    os.chdir(r'D:\Data\DevelopingAllenMouseAPI-master\Git')

    api = RmaApi()

    structures = pd.DataFrame(
        api.model_query('Structure',
                        criteria='[graph_id$eq17][st_level$eq5]\
                        [acronym$nev_r11A]\
                        [acronym$nev_r10A]\
                        [acronym$nev_SpB]\
                        [acronym$nev_POA]\
                        [acronym$nev_r5A]\
                        [acronym$nev_r5R]\
                        [acronym$nev_r3R]\
                        [acronym$nev_r11B]\
                        [acronym$nev_TelR]\
                        [acronym$nev_r6B]\
                        [acronym$nev_POR]\
                        [acronym$nev_r2F]\
                        [acronym$nev_r9B]\
                        [acronym$nev_m2R]\
                        [acronym$nev_r8R]\
                        [acronym$nev_r7R]\
                        [acronym$nev_THyB]\
                        [acronym$nev_m2A]\
                        [acronym$nev_r11F]\
                        [acronym$nev_isA]\
                        [acronym$nev_r6F]\
                        [acronym$nev_p3B]\
                        [acronym$nev_r9F]\
                        [acronym$nev_r3F]\
                        [acronym$nev_isF]\
                        [acronym$nev_m2B]\
                        [acronym$nev_r3F]\
                        [acronym$nev_isF]\
                        [acronym$nev_m2B]\
                        [acronym$nev_r8A]\
                        [acronym$nev_isR]\
                        [acronym$nev_r3B]\
                        [acronym$nev_SpF]\
                        [acronym$nev_r6R]\
                        [acronym$nev_r3A]\
                        [acronym$nev_r4A]\
                        [acronym$nev_r7F]\
                        [acronym$nev_r1F]\
                        [acronym$nev_r4B]\
                        [acronym$nev_r5F]\
                        [acronym$nev_THyF]\
                        [acronym$nev_p2A]\
                        [acronym$nev_r7B]\
                        [acronym$nev_SpA]\
                        [acronym$nev_r2B]\
                        [acronym$nev_r8F]\
                        [acronym$nev_p1A]\
                        [acronym$nev_r1R]\
                        [acronym$nev_p3A]\
                        [acronym$nev_p1R]\
                        [acronym$nev_p2B]\
                        [acronym$nev_TelA]\
                        [acronym$nev_r8B]\
                        [acronym$nev_m1R]\
                        [acronym$nev_r1A]\
                        [acronym$nev_r10B]\
                        [acronym$nev_p2R]\
                        [acronym$nev_p3R]\
                        [acronym$nev_r5B]\
                        [acronym$nev_isB]\
                        [acronym$nev_THyA]\
                        [acronym$nev_p1F]\
                        [acronym$nev_r1B]\
                        [acronym$nev_m1A]\
                        [acronym$nev_p2F]\
                        [acronym$nev_r4R]\
                        [acronym$nev_r4F]\
                        [acronym$nev_r9R]\
                        [acronym$nev_r9A]\
                        [acronym$nev_r10F]\
                        [acronym$nev_m2F]\
                        [acronym$nev_r10R]\
                        [acronym$nev_p1B]\
                        [acronym$nev_PHyB]\
                        [acronym$nev_r2R]\
                        [acronym$nev_r7A]\
                        [acronym$nev_p3F]\
                        [acronym$nev_r2A]\
                        [acronym$nev_SpR]\
                        [acronym$nev_m1F]\
                        [acronym$nev_r6A]\
                        [acronym$nev_r11R]\
                        [acronym$nev_m1B]\
                        [acronym$nev_PHyF]\
                        [acronym$nev_PHyA]\
                        [parent_structure_id$ne17651]',
                        num_rows='all'))

    abs_dir = os.path.dirname(__file__)
    rel_dir = os.path.join(abs_dir, './Data/API/Structures')
    data = ''.join([rel_dir, '/structureData_level5.csv'])
    structures.to_csv(data)

if __name__ == '__main__':
    main()
