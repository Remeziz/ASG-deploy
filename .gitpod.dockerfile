# Пример Dockerfile
FROM gitpod/workspace-full

# Устанавливаем, чтобы были доступны apt-get, lsb_release и gpg
# (в Gitpod/workspace-full обычно apt-get есть, но lsb_release/gpg может отсутствовать)
RUN sudo apt-get update && \
    sudo apt-get install -y gnupg lsb-release
# Теперь можно добавить репозиторий HashiCorp
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg \
    && sudo install -o root -g root -m 644 hashicorp.gpg /usr/share/keyrings/ \
    && rm -f hashicorp.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com \
       $(lsb_release -cs) main" \
       | sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && sudo apt-get update \
    && sudo apt-get install -y terraform