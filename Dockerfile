FROM pytorch/pytorch

# Set a working directory
WORKDIR /exe_eng_base

# Copy the requirements of your project into the container
COPY requirements.txt /exe_eng_base/

# Combine conda and pip installations into a single RUN command to reduce layers.
# Also clean up conda caches to reduce image size.
RUN conda install -c conda-forge "transformers>=4.38.0" "ffmpeg>=5" "pyarrow>=15" \
    && conda install seaborn pandas shapely scikit-learn scikit-image dropbox pymssql h5py unidecode  \
    && pip install --no-cache-dir --upgrade -r requirements.txt \
    && conda clean -afy

# Set timezone environment variable
ENV TZ=Europe/Bucharest
# Set the timezone based on the TZ environment variable
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Combine apt-get commands into one layer and clean up afterwards to reduce image size
# OBS: cannot combine with above RUN command due to the TZ variable not being set yet
RUN apt-get update && apt-get install -y \
    iputils-ping \
    tzdata \
    nano \
    # Clean up apt cache to reduce image size
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set generic environment variables
ENV AIXP_DOCKER Yes
ENV AIXP_ENV v1.4