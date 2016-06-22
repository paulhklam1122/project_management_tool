require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  # let(:project) {FactoryGirl.create(:project)}
  let(:project) { create(:project) }
  let(:user)     { create(:user) }
  def project
    @project ||= FactoryGirl.create(:project)
  end
  describe "#new" do
    context "with user not signed in" do
      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_sessions_path)
      end
    end
    context "with user signed in" do
      before { request.session[:user_id] = user.id }
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
      it "fetches" do
        get :new
        expect(assigns(:project)).to be_a_new(Project)
      end
    end
  end

  describe "#create" do
    context "with user not signed in" do
      it "redirects to the sign in page" do
        post :create, project: {title: "asdfasdf", body: "Hello world, I love programming.", due_date: "2019-01-01"}
        expect(response).to redirect_to(new_sessions_path)
      end
    end
    context "with user signed in" do
      before { request.session[:user_id] = user.id }

      context "with valid attributes" do
        def valid_request
          post :create, project: {title: "asdfasdf", body: "Hello world, I love programming.", due_date: "2019-01-01"}
        end
        it "creates the project in the database" do
          count_before = Project.count
          valid_request
          count_after = Project.count
          expect(count_after).to eq(count_before + 1)
        end
        it "redirects to the project show page" do
          valid_request
          expect(response).to redirect_to(project_path(project))
        end
        it "associates the project with the signed in user" do
          valid_request
          expect(Project.last.user).to eq(user)
        end
      end
      context "with invalid attributes" do
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
    context "with user not signed in" do
      it "redirects to the sign in page" do
        patch :update, project: {title: "asdfasdf", body: "Hello world, I love programming.", due_date: "2019-01-01"}
        expect(response).to redirect_to(new_sessions_path)
      end
    end
    context "with user signed in" do
      before { request.session[:user_id] = user.id }
      context "With valid attributes" do
        def valid_request
          patch :update, id: project.id, project: {title: "new valid title", description: "valid body", due_date: "2019-01-01"}
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
          patch :update, id: project.id, project: {title: ""}
        end
        it "doesn't save the updated values" do
          invalid_request
          expect(project.reload.title).not_to eq("")
        end
        it "renders the edit template" do
          invalid_request
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "#destroy" do
    let!(:project) {FactoryGirl.create(:project)}
    context "with user not signed in" do
      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_sessions_path)
      end
    end
    context "with user signed in" do
      before { request.session[:user_id] = user.id }
      it "removed the record from the database" do
        count_before = Project.count
        delete :destroy, id: project.id
        count_after = Project.count
        expect(count_before).to eq(count_after + 1)
      end
      it "redirects to the products_path (listings page)" do
        delete :destroy, id: project.id
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end
