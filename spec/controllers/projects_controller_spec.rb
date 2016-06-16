require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  # let(:project) {FactoryGirl.create(:project)}
  def project
    @project ||= FactoryGirl.create(:project)
  end
  describe "#new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
    it "fetches" do
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe "#create" do
    context "valid" do
      def valid_request
        post :create, project: FactoryGirl.attributes_for(:project)
      end
      it "saves the record" do
        count_before = Project.count
        valid_request
        count_after = Project.count
        expect(count_before).to eq(count_after - 1)
      end
      it "redirects to the page" do
        valid_request
        expect(response).to redirect_to(project_path(Project.last))
      end
    end
    context "invalid" do
      def invalid_request
        post :create, project: {body: "aa", due_date: "2019-01-01"}
      end
      it "doesn't save the record" do
        count_before = Project.count
        invalid_request
        count_after = Project.count
        expect(count_before).to eq(count_after)
      end
      it "render new template " do
        invalid_request
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#show" do
    before do
      # @project = FactoryGirl.create(:project)
      @project = project
      get :show, id: @project.id
    end
    it "renders the show template" do
      expect(response).to render_template(:show)
    end
    it "fetches" do
      expect(assigns(:project)).to eq(@project)
    end
  end

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
    it "sets posts instance variable to all posts in te DB" do
      project_1 = FactoryGirl.create(:project)
      project_2 = FactoryGirl.create(:project)
      get :index
      expect(assigns(:projects)).to eq([project_1, project_2])
    end
  end

  describe "#edit" do
    before do
      get :edit, id: project.id
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
      it "set an instance variable to the post with the id passed" do
        expect(assigns(:project)).to eq(project)
      end
  end

  describe "#update" do
    context "With valid attributes" do
      def valid_request
        patch :update, id: project.id, post: {title: "new valid title", description: "valid body", due_date: "2019-01-01"}
      end
      it "updates the record in the database" do
        valid_request
        expect(project.reload.title).to eq("new valid title")
      end
      it "redirects to the show page" do
        valid_request
        expect(response).to redirect_to(project_path(project))
      end
    end

    context "With invalid attributes" do
      def invalid_request
        patch :update, id: post1.id, post: {title: ""}
      end
      it "doesn't save the updated values" do
        invalid_request
        expect(post1.reload.title).not_to eq("")
      end
      it "renders the edit template" do
        invalid_request
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#destory" do
    #using let! forces the block to be executed before every test example regardless whether you call the method or not.
    let!(:post) {FactoryGirl.create(:post)}
    it "removes the record from the database" do
      # post
      count_before = Post.count
      delete :destroy, id: post.id
      count_after = Post.count
      expect(count_before).to eq(count_after + 1)
    end
    it "redirects to posts_path (listings page)" do
      delete :destroy, id: post.id
      expect(response).to redirect_to(posts_path)
    end
  end
end
