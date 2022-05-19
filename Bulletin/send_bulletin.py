import requests
import json
import telepot
import argparse
import time
import PIL
from PIL import Image, ImageDraw, ImageFont
import sys
from datetime import datetime

# Create bot (see https://medium.com/@ManHay_Hong/how-to-create-a-telegram-bot-and-send-messages-with-python-4cf314d9fa3e):
# - On Telegram, search @ BotFather, send him a “/start” message
# - Send another “/newbot” message, then follow the instructions to setup a name and a username
# - Copy API token
# - Go to bot in Telegram, and press /start
# - Bot can be accessed by others as well.
# - Once activated, user_id will be added to getUpdates response

def send_bulletin(token,chat_id,bulletin,method):

    file = bulletin
    
    bot = telepot.Bot(token)

	# Check chat ID's
	# url = 'https://api.telegram.org/bot' + token + '/getUpdates'
	# resp = requests.get(url)
	# r_json = json.loads(resp.text)
	# print('r_json:')
	# print(r_json)

    if method == 'file':
        print(chat_id)
        bot.sendPhoto(chat_id, photo=open(file, 'rb'))
    else:
        with open('bulletin.png', 'wb') as f:
            f.write(requests.get(file).content)
            f.close()
            time.sleep(3)

        print(chat_id)
        bot.sendPhoto(chat_id, photo=open('bulletin.png', 'rb'))
        

#Assign outcome images to variable
#surf_temp = Image.open(r"/usr/src/app/output/surf_temp.png")
arrival = Image.open(r"/usr/src/app/output/arrival.png")
grounds_map = Image.open(r"/usr/src/app/Bulletin/Oyster_grounds.png")
logo = Image.open(r"/usr/src/app/Bulletin/FORCOAST_Logo_WhiteBack.png")
footer = Image.open(r"/usr/src/app/Bulletin/FORCOAST_Footer_Blue.png")

#get height and width for all images
#surf_temp_width, surf_temp_height = surf_temp.size
arrival_width, arrival_height = arrival.size
grounds_map_width, grounds_map_height = grounds_map.size
logo_width, logo_height = logo.size
footer_width, footer_height= footer.size

#rescale
logo_new_width = 1000
logo_new_height = int((logo_new_width/logo_width)*logo_height)
logo_resize = logo.resize((logo_new_width, logo_new_height), PIL.Image.NEAREST)

grounds_map_new_width = 2000
grounds_map_new_height = int((grounds_map_new_width/grounds_map_width)*grounds_map_height)
grounds_map_resize = grounds_map.resize((grounds_map_new_width, grounds_map_new_height), PIL.Image.NEAREST)

#surf_temp_new_width = 3050
#surf_temp_new_height = int((surf_temp_new_width/surf_temp_width)*surf_temp_height)
#surf_temp_resize = surf_temp.resize((surf_temp_new_width, surf_temp_new_height), PIL.Image.NEAREST)

arrival_new_width = 3050
arrival_new_height = int((arrival_new_width/arrival_width)*arrival_height)
arrival_resize = arrival.resize((arrival_new_width, arrival_new_height), PIL.Image.NEAREST)

footer_new_width = 3150
footer_new_height = int((footer_new_width/footer_width)*footer_height)
footer_resize = footer.resize((footer_new_width, footer_new_height), PIL.Image.NEAREST)

#draw images on bulletin (non-parameter)
newBulletin = Image.new("RGBA", (3150, 2611), (255, 255, 255))
newBulletin.paste(grounds_map_resize, (1100, 150))
#newBulletin.paste(surf_temp_resize, (50, 1699))
newBulletin.paste(arrival_resize, (50, 1880))
newBulletin.paste(logo_resize, (50, 150))
newBulletin.paste(footer_resize, (0, 2511))
draw = PIL.ImageDraw.Draw(newBulletin)
font_title = ImageFont.truetype(r"/usr/src/app/Bulletin/arial.ttf", 100)
font_param = ImageFont.truetype(r"/usr/src/app/Bulletin/arial.ttf", 50)
draw.text((782, 0), 'A4: Assistance for spat captures', font = font_title, fill=(23,111,176,255))


if __name__ == '__main__':

    # Get input from command line arguments
    parser = argparse.ArgumentParser(description = "Description for my parser")
    parser.add_argument("-A", "--ndays", help = "Number of days parameter", required = True, default = "")
    parser.add_argument("-B", "--ptm", help = "Method parameter, switch temperature treshold (0) or cumalitve temperature (1)", required = True, default = "")
    parser.add_argument("-C", "--tt", help = "Treshold temperature parameter", required = True, default = "")
    parser.add_argument("-D", "--gdt", help = "treshold of temperature for gonade development parameter", required = True, default = "")
    parser.add_argument("-E", "--ttcs", help = "treshold of cumulative temperature parameter", required = True, default = "")
    parser.add_argument("-F", "--pldmin", help = "minimal pelagic larval duration of the selected species parameter", required = True, default = "")
    parser.add_argument("-G", "--pldmax", help = "maximal pelagic larval duration of the selected species parameter", required = True, default = "")
    parser.add_argument("-H", "--sd", help = "spawning duration parameter", required = True, default = "")
    parser.add_argument("-I", "--token", help = "Telegram bot token", required = True, default = "")
    parser.add_argument("-J", "--chat_id", help = "Telegram chat ID", required = True, default = "")
    parser.add_argument("-K", "--bulletin", help = "Bulletin to be send", required = True, default = "")
    parser.add_argument("-L", "--method", help = "Specify file or URL as input", required = False, default = "url")

    argument = parser.parse_args()
    
    #draw input parameters on bulletin
    now = datetime.now()
    dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
    
    draw.text((50, 800), 'Parameters:\n'\
                      '- Site: North-Sea\n'\
                      '- Number of days: {0}\n'\
                      '- Method: {1}\n'\
                      '- Threshold temperature: {2} (oC)\n'\
                      '- Threshold of temperature for gonade\n  development: {3} (oC)\n'\
                      '- Threshold of cumulative temperature: {4} (oC)\n'\
                      '- Minimal pelagic larval duration of\n  the selected species: {5}\n'\
                      '- Maximal pelagic larval duration of\n  the selected species parameter: {6}\n'\
                      '- Spawning duration: {7}\n'\
                      '- Bulletin generated on: {8}'
                      .format(argument.ndays, argument.ptm, argument.tt,\
                              argument.gdt, argument.ttcs, argument.pldmin,\
                              argument.pldmax, argument.sd, dt_string), \
                       font = font_param, fill=(23,111,176,255))
    #save bulletin
    newBulletin.save(r"/usr/src/app/output/bulletin.png", quality = 100)
    
    #take arguments and send bulletin
    if argument.token:
        token = argument.token
        print('Bot token = ' + token)
    if argument.chat_id:
        chat_id = argument.chat_id
        print('Chat ID = ' + chat_id)
    if argument.bulletin:
        bulletin = argument.bulletin
        print('Bulletin filename = ' + bulletin)
    if argument.method:
        method = argument.method
        print('Method = ' + method)

    send_bulletin(token,chat_id,bulletin,method)

