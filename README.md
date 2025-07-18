# 📦 TBC პრაქტიკული დავალება


## 📚 სარჩევი

- [Architecture](#architecture)
- [Infrastructure](#Infrastructure Details)
- [Variables](#variables)


## 🏗️ Architecture

- Diagram 
![Alt text](miro.png)

- EC2 instances - ჰოსტავენ სტატიკურ index.hmtl ფაილს apache2 სერვისის დახმარებით. index.html შეიცავს რეფერენს  Cloudfront-ის URL-ზე სურათის წამოსაღებად.
- S3 bucket - ადგილი სადაც სურათი ინახება, წვდომადია მხოლოდ CloudFront-დან (OAC)
- CloudFront - მოაქვს სურათი, ქეშავს და აწვდის ევბსერვერს
- Elastic IP - ქმნის სტატიკურ მისამართს ერთ-ერთი ვებსერვერისთვის.

## 🛠️ Infrastructure Details

List AWS resources:
- 2x EC2 instances
- 1x S3 bucket
- 1x CloudFront distribution
- 1x Elastic IP
- Security Groups 
