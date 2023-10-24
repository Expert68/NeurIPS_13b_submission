FROM ghcr.io/pytorch/pytorch-nightly:b3874ab-cu11.8.0

RUN apt-get update  && apt-get install -y git python3-virtualenv wget 

RUN pip install -U --no-cache-dir git+https://github.com/facebookresearch/llama-recipes.git@eafea7b366bde9dc3f0b66a4cb0a8788f560c793

WORKDIR /workspace
# Setup server requriements
COPY ./fast_api_requirements.txt fast_api_requirements.txt
RUN pip install --no-cache-dir --upgrade -r fast_api_requirements.txt

COPY ./requirements.txt requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt
# Copy over single file server
COPY main_full_model.py main.py
COPY ./api.py api.py
#COPY ./download.py download.py

#ENV HUGGINGFACE_TOKEN="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"
#ENV HUGGINGFACE_REPO="Expert68/llama2_peft_v4"

# RUN python download.py
# Run the server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
