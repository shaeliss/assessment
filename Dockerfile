FROM python:3.9

COPY hello_world.py .

RUN pip install flask

# Create a non-root user for running the application
RUN adduser -D -u 1001 myuser

# Change ownership and permissions for application files
RUN chown -R myuser:myuser hello_world.py \
    && chmod -R 750 .

# Switch to the non-root user
USER myuser

# Expose the necessary port(s)
EXPOSE 8080


CMD ["python", "hello_world.py"]
