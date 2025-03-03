export interface TeamMemberProps {
  image: string;
  name: string;
  role: string;
  linkedin?: string;
}

export interface TeamSectionProps {
  title: string;
  subtitle?: string;
  members: TeamMemberProps[];
  id?: string;  // Add this line
}