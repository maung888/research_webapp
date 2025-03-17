# db/seeds.rb

require 'securerandom'

# -------------------------------------
# 1) Create Users (along with roles)
# -------------------------------------
# admin_user = User.find_or_create_by!(email: 'davidvanderklay@tamu.edu') do |u|
#   u.name     = 'Admin User'
#   u.provider = 'google_oauth2'
#   u.uid      = '123' # A real UID in a real app
# end
#
# faculty_user = User.find_or_create_by!(email: 'davidvanderklay@gmail.com') do |u|
#   u.name     = 'Faculty User'
#   u.provider = 'google_oauth2'
#   u.uid      = '456'
# end
#
# student_user = User.find_or_create_by!(email: 'georgelantin@gmail.com') do |u|
#   u.name     = 'Student User'
#   u.provider = 'google_oauth2'
#   u.uid      = '789'
# end
#
# # If your admin/faculty/student models are just
# # single-table roles, you can do:
# admin_user.create_admin!
# faculty_user.create_faculty!(department: "CSCE")
# student_user.create_student!(year: 2024, major: "Computer Science")

puts "Users & Roles created or found."


# -------------------------------------
# 2) Create Projects
# -------------------------------------
project_list = [
  {
    name: "Nitesh Saxena",
    email: "nsaxena@tamu.edu",
    num_positions: 2,
    areas_of_research: "Cybersecurity and privacy (broadly defined)",
    start_semester: "Spring 2025",
    description: "We have a wide variety of projects that honors students can get involved with. For more info, please take a look at our lab's website: https://spies.engr.tamu.edu/",
    prefered_class: "Junior/Senior; Others with exceptional motivation",
    other_comments: ""
  },
  {
    name: "Guofei Gu",
    email: "guofei@cse.tamu.edu",
    num_positions: 2,
    areas_of_research: "Cybersecurity",
    start_semester: "Fall 2023",
    description: "Come to SUCCESS. Achieve Your Success!",
    prefered_class: "Junior/Senior",
    other_comments: "SUCCESS Lab: https://success.cse.tamu.edu/"
  },
  {
    name: "Ricardo Gutierrez",
    email: "rgutier@tamu.edu",
    num_positions: 2,
    areas_of_research: "Deep learning / digital health",
    start_semester: "Fall 2023",
    description: "Predicting health parameters from wearable sensors",
    prefered_class: "Junior/senior",
    other_comments: "Related pubs: 1, 2, 3 https://www.nature.com/articles/s41598-019-56927-5"
  },
  {
    name: "Ricardo Gutierrez",
    email: "rgutier@tamu.edu",
    num_positions: 2,
    areas_of_research: "Biofeedback games",
    start_semester: "Fall 2023",
    description: "Integrating wearable sensors with videogames",
    prefered_class: "Junior/senior",
    other_comments: "Related pubs: 1, 2, 3 https://psi.engr.tamu.edu/wp-content/uploads/2021/12/nitin2021frontiers.pdf"
  },
  {
    name: "Aakash Tyagi",
    email: "tyagi@cse.tamu.edu",
    num_positions: "varies",
    areas_of_research: "Machine Learning, Chip Design",
    start_semester: "Fall 2023",
    description: "ML application in Physical Design and Functional Verification of CHIPS.",
    prefered_class: "Junior",
    other_comments: "Must have done 1-2 courses in ML, DL. Some NLP awareness is a plus. Send mail to tyagi@tamu.edu."
  },
  {
    name: "Bobak Mortazavi",
    email: "bobakm@tamu.edu",
    num_positions: 1,
    areas_of_research: "Health Analytics / machine learning",
    start_semester: "Fall 2023",
    description: "Applications of machine learning analytics for health data",
    prefered_class: "Any level",
    other_comments: ""
  },
  {
    name: "Drew Hamilton",
    email: "hamilton@tamu.edu",
    num_positions: 2,
    areas_of_research: "SCADA Security Lab, Texas Cyber Range",
    start_semester: "Fall 2023",
    description: "Hands on work with our lab equipment",
    prefered_class: "Any Level",
    other_comments: "Send email to Justin Leiden for SCADA leiden@tamu.edu. Send email to John Romero for Cyber Range john.romero@tamu.edu"
  },
  {
    name: "Marcus Botacin",
    email: "botacin@tamu.edu",
    num_positions: 1,
    areas_of_research: "Cybersecurity",
    start_semester: "Spring 2025",
    description: "Break defenses. Build better ones!",
    prefered_class: "Any Level",
    other_comments: "Send email to schedule a meeting."
  },
  {
    name: "Tim Davis",
    email: "davis@tamu.edu",
    num_positions: "varies",
    areas_of_research: "Graph algorithms, sparse matrix methods",
    start_semester: "Fall 2024",
    description: "Graph algorithms based on semirings and sparse linear algebra",
    prefered_class: "Junior/senior",
    other_comments: "A short intro: https://youtu.be/wqjRzC2fPUo, playlist: https://youtube.com/playlist?list=PL5EvFKC69QIw3FqXj7UmiN1p-a-qYnZVK&si=-EqhghKhTRXQnWZj. The projects I have available are for writing graph algorithms for LAGraph that use GraphBLAS."
  },
  {
    name: "Martin Carlisle",
    email: "carlislem@tamu.edu",
    num_positions: 1,
    areas_of_research: "Cybersecurity",
    start_semester: "Spring 2025",
    description: "Applying machine learning to cybersecurity problems",
    prefered_class: "Junior/senior",
    other_comments: ""
  },
  {
    name: "Philip Ritchey",
    email: "pcr@tamu.edu",
    num_positions: 1,
    areas_of_research: "Software Engineering",
    start_semester: "Spring 2024",
    description: "Automated code generation from test cases",
    prefered_class: "Junior/senior",
    other_comments: "CSCE 314 and CSCE 315 a plus, CSCE 431 even bigger plus."
  },
  {
    name: "Chia-Che Tsai",
    email: "chiache@tamu.edu",
    num_positions: 1,
    areas_of_research: "Cloud computing",
    start_semester: "Spring 2024",
    description: "Exploring system trade-offs for next-generation serverless computing",
    prefered_class: "Junior/senior",
    other_comments: "Recommended to have taken CSCE 410."
  },
  {
    name: "Tracy Hammond",
    email: "hammond@tamu.edu",
    num_positions: "Any",
    areas_of_research: "Human AI, Eyetracking, Sketch Recognition, Activity Recognition, HCI, Accessibility, Belonging, Health during cognitive decline, child fine motor skills, inequality",
    start_semester: "Spring 2024",
    description: "Recognition messy human activities, creating new metrics, helping those with cognitive decline",
    prefered_class: "Any Level",
    other_comments: "Email Hammond@tamu.edu. Attend lab meeting."
  },
  {
    name: "Shuiwang Ji",
    email: "sji@tamu.edu",
    num_positions: "Any",
    areas_of_research: "Machine learning, deep learning, language models and agents",
    start_semester: "anytime",
    description: "https://khhuang.me/group.html#",
    prefered_class: "Any level, but early-stage undergrads are preferred, as I expect students to do significant work that might not be done within 1-2 semesters",
    other_comments: "Email sji@tamu.edu with resume and transcript"
  },
  {
    name: "Frank Shipman",
    email: "shipman@tamu.edu",
    num_positions: "Any",
    areas_of_research: "Human-computer interaction, AI, multimedia",
    start_semester: "anytime",
    description: "Examples include: social media tools and practices, educational games, crowdsourcing data quality, support for human expression and editing of knowledge graphs, AI explanation techniques and interfaces",
    prefered_class: "Any level",
    other_comments: "Email shipman@tamu.edu with resume and your interests (if topic already known)"
  },
  {
    name: "Robert Lightfoot",
    email: "rob.light@tamu.edu",
    num_positions: 1,
    areas_of_research: "Use of AI as tools in Software Engineering, cloud computing classrooms",
    start_semester: "anytime",
    description: "Computer science education, engineering education, AI as a tool",
    prefered_class: "jr/Sr",
    other_comments: "Email rob.light@tamu.edu"
  },
  {
    name: "Jeff Huang",
    email: "jeff@cse.tamu.edu",
    num_positions: 1,
    areas_of_research: "Programming Languages",
    start_semester: "Fall 2024/Spring 2025",
    description: "Rust, AI, and browser security",
    prefered_class: "Any level",
    other_comments: "Email jeff@cse.tamu.edu with subject 'pokemon'. Please attach your resume"
  },
  {
    name: "Tianbao Yang",
    email: "tianbao-yang@tamu.edu",
    num_positions: "Any",
    areas_of_research: "Machine learning, artificial intelligence, deep learning",
    start_semester: "anytime",
    description: "My lab is conducting research on foundational AI and machine learning. We are improving AI from various perspectives, from representation learning to generative models, from foundational AI to applied AI. I have supervised an honor's student in 2023-2024 and the student has been admitted to the master program of University of Cambridge.",
    prefered_class: "Any level",
    other_comments: "Email tianbao-yang@tamu.edu with resume and transcript"
  },
  {
    name: "Kuan-Hao Huang",
    email: "khhuang@tamu.edu",
    num_positions: 1,
    areas_of_research: "Natural language processing, large language models, multimodal learning",
    start_semester: "anytime",
    description: "We have several projects focusing on evaluating and improving the robustness and capabilities of large (vision-)language models in domains such as logical reasoning, image-text understanding, mathematics, and various other applications.",
    prefered_class: "Any level, but please keep it in mind that significant work in our field might take at least 2 semesters",
    other_comments: "Please take the undergrad-level NLP course first and email khhuang@tamu.edu with resume and transcript"
  },
  {
    name: "Cheng Zhang",
    email: "chzhang@tamu.edu",
    num_positions: "Any",
    areas_of_research: "Human-centered computer vision, responsible AI and generative AI, multimodal (vision + language)",
    start_semester: "anytime",
    description: "- [vision, graphics] understand and reconstruct human and scenes\n- [vision, machine learning] reliability and inclusiveness-driven generative AI\n- [vision, language, action] language as a scaffold for visual and robot intelligence",
    prefered_class: "Any level",
    other_comments: "Email chzhang@tamu.edu with resume and transcript"
  },
  {
    name: "Ruihong Huang",
    email: "huangrh@tamu.edu",
    num_positions: 2,
    areas_of_research: "Natural Language Processing",
    start_semester: "anytime",
    description: "Detecting and mitigating social biases of large language models; video understanding and captioning",
    prefered_class: "Any level",
    other_comments: ""
  },
  {
    name: "Shreyas Kumar",
    email: "shreyas.kumar@tamu.edu",
    num_positions: 4,
    areas_of_research: "Applied Cybersecurity, Cyber Warfare",
    start_semester: "Spring 2025",
    description: "Cybersecurity to secure daily life, Cyber Warfare, Cyber Risk, Law & Privacy",
    prefered_class: "Any level",
    other_comments: "Email with subject 'INTEREST IN RESEARCH' with resume, transcripts, and your interests"
  },
  {
    name: "Wenping Wang",
    email: "wenping@tamu.edu",
    num_positions: 4,
    areas_of_research: "Shape modeling and computer vision",
    start_semester: "Spring 2025",
    description: "Surface representation, 3D reconstruction, mesh generation",
    prefered_class: "Junior or Senior",
    other_comments: ""
  },
  {
    name: "Roger Pearce",
    email: "rpearce@tamu.edu",
    num_positions: 1,
    areas_of_research: "High Performance Computing, Graph Analytics",
    start_semester: "anytime",
    description: "Variety of projects related to large scale data analytics for HPC",
    prefered_class: "Junior/Senior",
    other_comments: ""
  },
  {
    name: "Samson Zhou",
    email: "samsonzhou@tamu.edu",
    num_positions: 1,
    areas_of_research: "Theory",
    start_semester: "Spring 2025",
    description: "Design and analysis of algorithms",
    prefered_class: "Junior/Senior",
    other_comments: "CSCE 411 and/or mathematical maturity a plus. E-mail samsonzhou@tamu.edu with resume and transcript."
  },
  {
    name: "Dmitri Loguinov",
    email: "dmitri@tamu.edu",
    num_positions: 1,
    areas_of_research: "High performance computing, systems, optimization",
    start_semester: "anytime",
    description: "Algorithms for sorting, big-data frameworks, external-memory computing, graphs, multi-threading and parallelization",
    prefered_class: "Any",
    other_comments: "Strong coding ability in C/C++; CSCE 313 (honors) is a plus"
  },
  {
    name: "Yang Shen",
    email: "yshen@tamu.edu",
    num_positions: "Any",
    areas_of_research: "Multimodal machine learning for bioinformatics",
    start_semester: "anytime",
    description: "Multimodal representation learning, generation, explainability, generalizability, and uncertainty quantification for text, image, graph, and geometry, with applications to designing therapeutic molecules and predicting genetic-variant effects.",
    prefered_class: "Any",
    other_comments: "Email yshen@tamu.edu with resume and transcript. See the playlist for some of our past undergrad projects: https://www.youtube.com/playlist?list=PLOPwZv_49GaRRuMIHPHpX3viq4-ldpBWc"
  },
  {
    name: "Tracy Hammond",
    email: "hammond@tamu.edu",
    num_positions: "Any",
    areas_of_research: "AI/ML/HCI/Eng Ed/Haptics/Blind/Recognizing Human Actions",
    start_semester: "anytime",
    description: "Topics: Sketch Recognition, Human Activity Recognition, Eye-tracking, Haptics, Intelligent User Interfaces, Artificial Intelligence, Machine Learning, Deep Learning, Generative AI, Data Science, Explainable AI, Human-Computer Interaction, Computer Vision, Accessibility, Technologies for the Blind, Child Development Assessment, Health Based Wearable Interfaces and Solutions for Cognitive Decline & Other Neurological Conditions, Engineering Education, Computer Education.",
    prefered_class: "Any",
    other_comments: "Students of any year or major can participate. Expectations: Students should register for 491/291 credits. (1 credit of 291 for First/Second years). Students are expected to complete an undergraduate thesis. How to get Involved: Send a note to https://srltamu.com/contact.php, Email Dr. Hammond or Email or contact any of the graduate students, Attend a lab meeting to meet other students. Note that if you don't receive a response back, please email again to get to the top of the email chain."
  }
]

project_list.each do |data|
  # Make or find the user (Faculty).
  user = User.find_or_create_by!(email: data[:email]) do |u|
    u.name     = data[:name]
    u.uid      = SecureRandom.uuid
    u.provider = "manual"
  end


# Ensure this user has a Faculty record.
# If your logic is that every user with
# these emails should be faculty, do so:
faculty = Faculty.find_or_create_by!(user: user) do |f|
  f.department = "CSCE"  # Set default department
end


project = Project.create!(
  title: "#{data[:name]} Research",
  description: data[:description],
  num_positions: data[:num_positions] || 0,
  areas_of_research: data[:areas_of_research],
  start_semester: data[:start_semester],
  prefered_class: data[:prefered_class],
  other_comments: data[:other_comments]
)

  # Link project <-> faculty in the join table
  project.faculties << faculty unless project.faculties.include?(faculty)
end

puts "Seeded #{project_list.size} projects successfully!"
