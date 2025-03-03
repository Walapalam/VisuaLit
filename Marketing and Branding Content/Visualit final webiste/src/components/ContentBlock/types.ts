import { TFunction } from "react-i18next";
export interface ContentBlockProps {
  title: string;
  content: string;
  section?: any;
  button?: any;
  t?: any;
  id: string;
  direction: "left" | "right";
  icon?: string | React.ReactNode; // Update this line to accept both string and ReactNode
  extraContent?: React.ReactNode;
}
