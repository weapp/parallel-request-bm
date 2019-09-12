import asyncio
import aiohttp
import time

async def fetch_one(session, q):
    params = {"q": q, "limit": 10, "api_key": "wpIEMb2sMw3VrQnzZEXhnYdNxFCLsRLT"}
    resp = await session.get("http://api.giphy.com/v1/gifs/search", params=params)
    json = await resp.json()
    return sum(int(data["images"]["fixed_height_still"].get("size",0)) for data in json["data"])

async def main(terms):
    t = time.time()
    async with aiohttp.ClientSession() as session:
        print(sum(await asyncio.gather(*(fetch_one(session, term) for term in terms))))
    print (time.time() - t)

if __name__ == "__main__":
    with open("40.txt") as infile:
        terms = set(map(str.strip, infile))

    asyncio.run(main(terms=terms))
