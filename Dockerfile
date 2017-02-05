# FROM python:3.6-alpine
FROM python:3.6

WORKDIR /usr/src/app
RUN mkdir -p /etc/homeassistant

# build-essential is required for python pillow module on non-x86_64 arch
RUN apt-get update && apt-get -y install --no-install-recommends \
  build-essential

# homeassistant.components.device_tracker.nmap_tracker
RUN apt-get update && apt-get -y install --no-install-recommends \
  nmap net-tools libcurl3-dev

# homeassistant.components.device_tracker.bluetooth_tracker
RUN apt-get update && apt-get -y install --no-install-recommends \
  bluetooth libglib2.0-dev libbluetooth-dev

# # Required debian packages for building dependencies
# RUN apt-get update && apt-get -y install --no-install-recommends \
#   cmake git
#
# # homeassistant.components.tellstick
# RUN echo "deb http://download.telldus.com/debian/ stable main" >> /etc/apt/sources.list.d/telldus.list \
#   && wget -qO - http://download.telldus.se/debian/telldus-public.key | apt-key add - \
#   && apt-get update && apt-get install -y --no-install-recommends libtelldus-core2
#
# # homeassistant.components.image_processing.openalpr_local
# RUN apt-get install -y --no-install-recommends \
#     libopencv-dev libtesseract-dev libleptonica-dev liblog4cplus-dev libxrandr-dev \
#   && git clone https://github.com/openalpr/openalpr.git /usr/local/src/openalpr \
#   && cd /usr/local/src/openalpr/src \
#   && mkdir -p build \
#   && cd build \
#   && cmake -DWITH_TEST=FALSE -DWITH_BINDING_JAVA=FALSE --DWITH_BINDING_PYTHON=FALSE --DWITH_BINDING_GO=FALSE -DWITH_DAEMON=FALSE -DCMAKE_INSTALL_PREFIX:PATH=/usr/local .. \
#   && make \
#   && make install
#
# # ffmpeg
# RUN echo "deb http://deb.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
#   && apt-get update && apt-get install -y --no-install-recommends -t jessie-backports ffmpeg

# if [ "$INSTALL_OPENZWAVE" == "yes" ]; then
#   virtualization/Docker/scripts/python_openzwave
  # python-openzwave
  # cython3 libudev-dev
# fi
#
# if [ "$INSTALL_LIBCEC" == "yes" ]; then
#   virtualization/Docker/scripts/libcec
  # libcec
  # swig
# fi
#
# if [ "$INSTALL_PHANTOMJS" == "yes" ]; then
#   virtualization/Docker/scripts/phantomjs
# fi



COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt \
  && pip install --no-cache-dir mysqlclient psycopg2 uvloop

# RUN mkdir homeassistant \
#   && curl -SL https://github.com/home-assistant/home-assistant/archive/0.37.1.tar.gz \
#     | tar -xz -C homeassistant --strip-components 2 home-assistant-0.37.1/homeassistant

RUN curl -SL https://github.com/home-assistant/home-assistant/archive/0.37.1.tar.gz \
  | tar -xz --strip-components 1 home-assistant-0.37.1/homeassistant

CMD [ "python", "-m", "homeassistant", "--config", "/etc/homeassistant" ]
