FROM python:3.9

COPY hello_world.py .

RUN pip install flask

CMD ["python", "hello_world.py"]
