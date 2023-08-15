FROM python

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install iputils-ping -y && apt-get install iproute2 -y && apt-get install openrc -y

RUN echo '#!/bin/sh' >> /etc/init.d/python.start
RUN echo 'cd /usr/src/app/' >> /etc/init.d/python.start
RUN echo 'FLASK_APP=main.py flask run --host=0.0.0.0 && reboot || reboot' >> /etc/init.d/python.start
RUN chmod +x /etc/init.d/python.start

COPY . .

CMD [ "FLASK_APP=main.py", "flask", "run" ]]
