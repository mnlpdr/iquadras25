class BulletinBoardService
  include HTTParty
  base_uri 'http://localhost:3000/bulletin_board/api'
  
  def self.get_posts(filters = {})
    response = get('/posts', query: filters)
    JSON.parse(response.body)
  rescue => e
    Rails.logger.error("Erro ao buscar posts do Bulletin Board: #{e.message}")
    []
  end
  
  def self.get_post(id)
    response = get("/posts/#{id}")
    JSON.parse(response.body)
  rescue => e
    Rails.logger.error("Erro ao buscar post do Bulletin Board: #{e.message}")
    nil
  end
  
  def self.create_post(post_params)
    response = post('/posts', body: { post: post_params })
    JSON.parse(response.body)
  rescue => e
    Rails.logger.error("Erro ao criar post no Bulletin Board: #{e.message}")
    { errors: [e.message] }
  end
end 