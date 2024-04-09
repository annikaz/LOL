import json
import re
import requests
import time

from selenium import webdriver
from bs4 import BeautifulSoup
from selenium.webdriver.common.keys import Keys

VERSIONS_URL = "https://ddragon.leagueoflegends.com/api/versions.json"
CHAMPIONS_URL ="https://ddragon.leagueoflegends.com/cdn/{patch}/data/en_US/champion.json"
CHAMPION_NAME_REPLACEMENTS = [("BelVeth", "Belveth"), ("Wukong", "MonkeyKing"), ("RenataGlasc", "Renata"), ("VelKoz", "Velkoz"), ("KhaZix", "Khazix"), ("ChoGath", "Chogath"), ("NunuWillump", "Nunu"), ("KaiSa", "Kaisa"), ("LeBlanc", "Leblanc")]
UGG_TIER_LIST_LOCATION = "./tierList.html"
def get_latest_version():
    try:
        response = requests.get(VERSIONS_URL)
        data = response.json()
        return data[0]
    except:
        print("Error getting latest version")
        return None
def get_champions():
    url = CHAMPIONS_URL.format(patch=get_latest_version())
    try:
        response = requests.get(url)
        data = response.json()
        champion_data = data["data"]
        return champion_data
    except:
        print("Error getting champions")
        return None
    
def add_ugg_statistics(championMap):
    with open(UGG_TIER_LIST_LOCATION) as fp:
        soup = BeautifulSoup(fp, 'html.parser')
        tier_list = soup.find_all("div", class_="rt-tr-group")
        for tier in tier_list:
            champion_name = tier.find("strong", class_="champion-name").text

            champion_name = re.sub(r'\W+', '', champion_name)
            for replacement in CHAMPION_NAME_REPLACEMENTS:
                if replacement[0] == champion_name:
                    champion_name = replacement[1]
            champion_role = tier.find("img", alt=True,class_="tier-list-role").get("alt")
            champion_json = championMap[champion_name]
            if "role" in champion_json:
                champion_json["role"].append(champion_role)
            else : 
                champion_json["role"] = [champion_role]
def champion_map_to_prolog(championMap):
    with open("champions.pl", "w") as fp:
        for champion in championMap:
            champion_json = championMap[champion]
            champion_name = champion_json["id"]
            # convert name to lowecase
            champion_name = champion_name.lower()
            champion_type = champion_json["tags"][0] 
            champion_type = champion_type.lower()
            champion_roles= champion_json["role"]
            
            champion_difficulty = champion_json["info"]["difficulty"]
            if (champion_difficulty < 3):
                champion_difficulty = "beginner"
            elif (champion_difficulty < 6):
                champion_difficulty = "intermediate"
            else:    
                champion_difficulty = "advanced"
            for champion_role in champion_roles:
                champion_role = champion_role.lower()
                if (champion_role == "supp"):
                    champion_role = "support"
                fp.write(f"hero({champion_name}, {champion_role}, {champion_type}, {champion_difficulty}).\n")
def main(): 
    championMap = get_champions()
    add_ugg_statistics(championMap=championMap)
    champion_map_to_prolog(championMap=championMap)
    return
if __name__ == "__main__":
    main()