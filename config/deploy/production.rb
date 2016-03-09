server '178.62.199.57', roles: %w{app db web}, ssh_options: {
       user: 'yufu',
       forward_agent: true,
       password: fetch(:password),
       auth_methods: %w(password)
    }