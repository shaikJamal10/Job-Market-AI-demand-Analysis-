import requests
from bs4 import BeautifulSoup
import html
url = "https://boards-api.greenhouse.io/v1/boards/tide/jobs?content=true"

response = requests.get(url)

print("Status code:", response.status_code)

data = response.json()

jobs=data["jobs"]
print("Numbers of jobs: ",len(jobs))
job_data=[]
for job in jobs:
   

    decoded_content=html.unescape(job["content"])
    soup=BeautifulSoup(decoded_content,"html.parser")
    clean_text=soup.get_text(separator=" ",strip=True)
    record={
        "job_id": job["id"],
        "title": job["title"],
        "company": job["company_name"],
        "location": job["location"]["name"],
        "url": job["absolute_url"],
        "published": job["first_published"],
        "updated": job["updated_at"],
        "description": clean_text
    }
    job_data.append(record)
print("Records Collected:",len(job_data))
print(job_data[0])



